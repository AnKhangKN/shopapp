import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/services/user_services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String? _message;

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    );
    return emailRegex.hasMatch(email);
  }

  void _handleSendOtp() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _message = "Vui lòng nhập email.";
      });
      return;
    }

    if (!isValidEmail(email)) {
      setState(() {
        _message = "Email không hợp lệ.";
      });
      return;
    }

    try {
      await UserServices().sendOtp(email);
      setState(() {
        _message = null;
      });
      context.pushNamed(
        'verify-otp',
        extra: _emailController.text.trim(), // Truyền email sang màn sau
      );
    } catch (e) {
      setState(() {
        _message = "Lỗi khi gửi OTP: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Nhập email'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: BackButton(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bạn đã quên mật khẩu?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Vui lòng nhập địa chỉ email của bạn để đặt lại mật khẩu.",
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Địa chỉ email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!isValidEmail(value.trim())) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleSendOtp();
                    }
                  },
                  child: Text("Gửi OTP",
                  style: TextStyle(
                    color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (_message != null) ...[
                SizedBox(height: 20),
                Text(
                  _message!,
                  style: TextStyle(color: Colors.green),
                ),
              ],
              SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Quay lại màn login
                  },
                  child: Text(
                    "< Quay lại đăng nhập",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
