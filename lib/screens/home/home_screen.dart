import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/screens/login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.search),
            onPressed: () {
              final currentLocation = GoRouter
                  .of(
                context,
              )
                  .routerDelegate
                  .currentConfiguration
                  .uri
                  .toString();
              context.go('/search?from=$currentLocation');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
          Container(
          child: Text(
          "Good Evening, ...",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),

        Row(
          children: [
        Container(
        child: Text(
        "Top Picks for you",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      Container(
          child: ElevatedButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }, child: Text("Đăng nhập"))
      ),
    ],
    ),
    ],
    ),
    ),
    )
    ,
    );
  }
}
