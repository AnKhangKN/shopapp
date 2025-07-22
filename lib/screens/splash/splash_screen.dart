import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/models/token_storage.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }
//
//   Future<void> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     // Tạm delay 1 giây để thấy splash
//     await Future.delayed(const Duration(seconds: 1));
//
//     if (token != null && token.isNotEmpty) {
//       // Nếu đã có token → chuyển sang Home
//       context.goNamed('home');
//     } else {
//       // Nếu chưa đăng nhập → chuyển sang Login
//       context.goNamed('login');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(), // loading
//       ),
//     );
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await TokenStorage.getToken();

    await Future.delayed(const Duration(seconds: 1));

    // 👇 Đảm bảo context đã build xong
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (token != null && token.isNotEmpty) {
        context.goNamed('home');
      } else {
        context.goNamed('login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo_nike.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
              // const SizedBox(height: 20),
              // const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}