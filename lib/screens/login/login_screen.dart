import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/models/token_storage.dart';
import 'package:shopapp/screens/home/home_screen.dart';
import 'package:shopapp/screens/signup/signup_screen.dart';
import 'package:shopapp/services/user_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  String? _loginError;

  Future<void> _handleLogin() async {
    final token = await TokenStorage.getToken();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loginError = null; // reset lỗi cũ
      });

      try {
        final res = await UserServices().loginUser(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (res.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đăng nhập thành công!')),
          );
          context.goNamed('splash');
        }
      } catch (e) {
        // Nếu đăng nhập thất bại, gán lỗi để hiển thị trong TextFormField
        setState(() {
          _loginError = 'Email hoặc mật khẩu không đúng';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.white, // đổi sang Colors.black nếu dark theme
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // Logo hoặc chữ Nike
              const Center(
                child: Text(
                  'NIKE',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Tiêu đề
              Center(
                child: const Text(
                  'Chào mừng trở lại',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: const Text(
                  'Đăng nhập để tiếp tục mua sắm',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 30),

              // Form đăng nhập
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Nhập email' : null,
                    ),

                    const SizedBox(height: 20),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        errorText: _loginError,
                      ),
                      validator: (value) => value == null || value.length < 6
                          ? 'Ít nhất 6 ký tự'
                          : null,
                    ),

                    const SizedBox(height: 10),

                    // Quên mật khẩu
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Chuyển sang màn Quên mật khẩu
                          context.pushNamed('forgot-password');
                        },
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Nút Đăng nhập
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Chưa có tài khoản?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Bạn chưa có tài khoản?'),
                        TextButton(
                          onPressed: () {
                            // TODO: Chuyển sang trang Đăng ký
                            context.pushNamed('signup');
                          },
                          child: const Text('Đăng ký'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
