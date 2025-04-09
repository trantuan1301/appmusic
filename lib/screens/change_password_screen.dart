import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_cubit.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _changePassword() async {
    setState(() => _isLoading = true);
    final authCubit = context.read<AuthCubit>();
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu mới và xác nhận không khớp')),
      );
      setState(() => _isLoading = false);
      return;
    }

    final result = await authCubit.changePassword(oldPassword, newPassword);
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result ? 'Đổi mật khẩu thành công' : 'Sai mật khẩu cũ'),
      ),
    );

    if (result) Navigator.pop(context);
  }

  Widget _buildPasswordField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đổi mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPasswordField(
                  label: 'Mật khẩu cũ',
                  icon: Icons.lock_outline,
                  controller: _oldPasswordController,
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  label: 'Mật khẩu mới',
                  icon: Icons.lock,
                  controller: _newPasswordController,
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  label: 'Xác nhận mật khẩu mới',
                  icon: Icons.lock_reset,
                  controller: _confirmPasswordController,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _changePassword,
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Đổi mật khẩu'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
