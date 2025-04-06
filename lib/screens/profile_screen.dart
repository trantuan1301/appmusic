import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/auth/auth_cubit.dart';
import '../models/user_model.dart';
import 'auth/login_screen.dart';
import 'package:music_app/screens/change_password_screen.dart';
import 'package:music_app/screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  final String avatarAssetPath = 'assets/music-player.png';
  final String userName = 'Nguyễn Văn A';
  final String email = 'nguyenvana@gmail.com';

  UserModel? userModel;
  String? _profileImagePath;
  String? _idCardImagePath;
  String? _driverLicenseImagePath;
  bool isLoading = false;

  Future<void> _loadUser() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (snapshot.exists) {
        setState(() {
          _profileImagePath = snapshot.data()?['profileImage'];
          _idCardImagePath = snapshot.data()?['idCardImagePath'];
          _driverLicenseImagePath = snapshot.data()?['driverLicenseImagePath'];
        });
      }

      final user = await getUserByUid(userId);
      if (user != null) {
        setState(() {
          userModel = user;
          isLoading = false;
        });
      }
    }
    setState(() => isLoading = false);
  }

  Future<UserModel?> getUserByUid(String uid) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromMap(snapshot.data()!);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(FirebaseAuth.instance)),
      ],
      child: Scaffold(
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthInitial) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 24),
                _buildMenuOption(
                  icon: Icons.image,
                  title: 'Chỉnh sửa ảnh avatar',
                  onTap: () {},
                ),
                _buildMenuOption(
                  icon: Icons.lock,
                  title: 'Đổi mật khẩu',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuOption(
                  icon: Icons.settings,
                  title: 'Cài đặt',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                const Divider(height: 32),
                _buildMenuOption(
                  icon: Icons.logout,
                  title: 'Đăng xuất',
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(radius: 50, backgroundImage: AssetImage(avatarAssetPath)),
        const SizedBox(height: 12),
        Text(
          'Xin chào',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(userModel?.email ?? '', style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Theme.of(context).primaryColor),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.black, fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Đăng xuất'),
            content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().logout();
                  Navigator.of(context).pop(); // Đóng dialog trước
                  Navigator.pushReplacement(
                    // Đẩy login và thay thế luôn màn hiện tại
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Đã đăng xuất')));
                },

                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Đăng xuất'),
              ),
            ],
          ),
    );
  }
}
