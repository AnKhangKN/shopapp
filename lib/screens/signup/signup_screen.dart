import 'package:flutter/material.dart';
import 'package:shopapp/services/user_services.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;

  String? _serverEmailError;

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        final res = await UserServices().registerUser(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          userName: _nameController.text.trim(),
        );

        if (_passwordController.text != _confirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Mật khẩu nhập lại không khớp")),
          );
          return;
        }

        if (res.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.data['message'] ?? 'Đăng ký thành công!'),
            ),
          );
          Navigator.pop(context); // chuyển về màn đăng nhập nếu muốn
        }
      } catch (e) {
        final errorMessage = e.toString().replaceAll('Exception: ', '');

        if (errorMessage.contains('Email đã tồn tại')) {
          setState(() {
            _serverEmailError = errorMessage;
          });
          _formKey.currentState!.validate(); // ép buộc form cập nhật lỗi
        } else {
          // Hiển thị lỗi khác (ngoài email), vẫn dùng SnackBar
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),

              Center(
                child: const Text(
                  'Tạo tài khoản Nike',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: const Text(
                  'Hãy điền thông tin để bắt đầu mua sắm',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),

              // Họ tên
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Vui lòng nhập tên' : null,
              ),

              const SizedBox(height: 20),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }

                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }

                  // ✅ Nếu có lỗi từ server (ví dụ: email đã tồn tại), trả về lỗi đó
                  if (_serverEmailError != null) {
                    final error = _serverEmailError!;
                    _serverEmailError = null; // reset sau khi hiển thị
                    return error;
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Mật khẩu
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) =>
                    value!.length < 6 ? 'Ít nhất 6 ký tự' : null,
              ),

              const SizedBox(height: 20),

              // Nhập lại mật khẩu
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nhập lại mật khẩu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value != _passwordController.text
                    ? 'Mật khẩu không khớp'
                    : null,
              ),

              const SizedBox(height: 30),

              // Nút Đăng ký
              ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              // Quay lại đăng nhập
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Đã có tài khoản?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Trở lại LoginPage
                    },
                    child: const Text('Đăng nhập'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
