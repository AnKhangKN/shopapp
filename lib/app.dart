import 'package:flutter/material.dart';
import 'package:shopapp/constants/app_colors.dart';
import 'package:shopapp/routes/app_routes.dart'; // file chứa GoRouter

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Shop App',
      // theme: ThemeData.dark(),
      theme: ThemeData.light(),
      routerConfig: router,
    );
  }
}
