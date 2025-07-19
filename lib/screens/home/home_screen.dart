import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/models/product_models.dart';
import 'package:shopapp/screens/login/login_screen.dart';
import 'package:shopapp/services/product_services.dart';
// import 'package:shopapp/widgets/card_in_home/product_card.dart';
import 'package:shopapp/services/user_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.search),
            onPressed: () {
              final currentLocation = GoRouter.of(
                context,
              ).routerDelegate.currentConfiguration.uri.toString();
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
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('token');
                        context.goNamed('login'); // chuyển về Login
                      },
                      child: Text("Đăng xuất"),
                    ),
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
