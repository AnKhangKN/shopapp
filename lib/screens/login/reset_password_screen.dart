import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/services/user_services.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _message;

  void _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await UserServices().resetPassword(
        widget.email,
        _newPasswordController.text.trim(),
      );

      setState(() {
        _message = "✅ Mật khẩu đã được đặt lại thành công!";
      });

      // Điều hướng về màn đăng nhập sau 2 giây
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) context.goNamed('login');
    } catch (e) {
      setState(() {
        _message = "❌ Lỗi: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu mới';
    if (value.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _newPasswordController.text) return 'Mật khẩu không khớp';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt lại mật khẩu'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Nhập mật khẩu mới cho email đã xác minh",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: "Mật khẩu mới",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: "Xác nhận mật khẩu",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleResetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Xác nhận", style: TextStyle(color: Colors.white)),
                ),
              ),

              if (_message != null) ...[
                const SizedBox(height: 16),
                Text(_message!, style: TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
