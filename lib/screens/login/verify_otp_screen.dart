import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/services/user_services.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  const VerifyOtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  void _handleVerifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await UserServices().verifyOtp(
        widget.email, // Không cần lấy từ TextField nữa
        _otpController.text.trim(),
      );

      context.goNamed('reset-password', extra: widget.email);
    } catch (e) {
      setState(() {
        _message = "❌ Xác minh thất bại: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập mã OTP';
    }

    if (value.trim().length != 6) {
      return 'Mã OTP phải gồm 6 chữ số';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác minh OTP'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // dùng formKey để validate
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Mã OTP đã được gửi đến: ${widget.email}"),
              const SizedBox(height: 16),

              TextFormField(
                controller: _otpController,
                decoration: const InputDecoration(
                  labelText: "Mã OTP",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: _validateOtp,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Xác minh OTP", style: TextStyle(color: Colors.white)),
                ),
              ),

              if (_message != null) ...[
                const SizedBox(height: 16),
                Text(_message!, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Text("< Quay lại đăng nhập", style: TextStyle(color: Colors.grey[700])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
