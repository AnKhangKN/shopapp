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

    // Tạm delay 1 giây để thấy splash
    await Future.delayed(const Duration(seconds: 1));

    if (token != null && token.isNotEmpty) {
      context.goNamed('home'); // Đã đăng nhập
    } else {
      context.goNamed('login'); // Chưa đăng nhập
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Loading
      ),
    );
  }
}