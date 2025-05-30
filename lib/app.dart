import 'package:flutter/material.dart';
import 'package:shopapp/routes/app_routes.dart'; // file chứa GoRouter

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Shop App',
      routerConfig: router,
    );
  }
}
