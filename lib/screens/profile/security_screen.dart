import 'package:flutter/material.dart';
import 'package:shopapp/services/profile_services.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _emailController = TextEditingController();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final _profileServices = ProfileServices();

  void _updateEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar("Vui lòng nhập email mới.");
      return;
    }

    try {
      final success = await _profileServices.changeEmail(email);

      if (success) {
        _showSnackBar("Email đã được cập nhật thành công.");
      } else {
        _showSnackBar("Email đã tồn tại hoặc có lỗi xảy ra.");
      }
    } catch (e) {
      _showSnackBar("Đã xảy ra lỗi không xác định.");
    }
  }

  void _changePassword() async {
    final current = _currentPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      _showSnackBar("Vui lòng nhập đầy đủ thông tin.");
      return;
    }

    if (newPass != confirm) {
      _showSnackBar("Mật khẩu mới và xác nhận không khớp.");
      return;
    }

    if (newPass.length < 6) {
      _showSnackBar("Mật khẩu mới lớn hơn 6 kí tự.");
      return;
    }

    try {
      final success = await _profileServices.changePassword(current, newPass, confirm);

      if (success) {
        _showSnackBar("Mật khẩu đã được thay đổi thành công.");
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    } catch (error) {
      _showSnackBar(error.toString().replaceFirst("Exception: ", ""));
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cài đặt bảo mật")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Cập nhật email
            const Text("Cập nhật Email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email mới",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _updateEmail,
              child: const Text("Cập nhật Email"),
            ),

            const SizedBox(height: 32),

            /// Đổi mật khẩu
            const Text("Đổi mật khẩu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _currentPasswordController,
              decoration: const InputDecoration(
                labelText: "Mật khẩu hiện tại",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: "Mật khẩu mới",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: "Xác nhận mật khẩu mới",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text("Đổi mật khẩu"),
            ),
          ],
        ),
      ),
    );
  }
}
