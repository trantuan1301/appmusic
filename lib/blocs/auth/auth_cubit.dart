import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/user_service.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthCubit(this._auth) : super(AuthInitial());

  final userService = UserService();

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        try {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': email,
          });
          emit(AuthSuccess("Đăng ký thành công!", user.uid));
        } catch (firestoreError) {
          print(" Firestore error: $firestoreError");
          emit(AuthFailure("Lỗi lưu thông tin người dùng: $firestoreError"));
        }
      } else {
        emit(AuthFailure("Đăng ký thất bại!"));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "Lỗi không xác định"));
    } catch (e) {
      print("Lỗi hệ thống chi tiết: $e");
      emit(AuthFailure("Lỗi hệ thống: $e"));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;

      if (uid == null) {
        emit(AuthFailure("Đăng nhập thất bại"));
        return;
      }

      final userModel = await userService.getUserByUid(uid);

      if (userModel == null) {
        emit(AuthFailure("Không tìm thấy thông tin người dùng"));
        return;
      }

      emit(AuthSuccess("Đăng nhập thành công", userModel.uid));
    } catch (e) {
      emit(AuthFailure("Lỗi đăng nhập"));
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final email = user.email;
      if (email == null) return false;

      final credential = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      print("Error changing password: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    emit(AuthInitial());
  }
}
