import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/widgets/CustomAppBar/CustomAppBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [

          IconButton(
            icon: const Icon(FeatherIcons.search),
            onPressed: () {
              context.go('/search');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to Home!'),
      ),
    );
  }
}
