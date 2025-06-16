import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';

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
              final currentLocation = GoRouter.of(
                context,
              ).routerDelegate.currentConfiguration.uri.toString();
              context.go('/search?from=$currentLocation');
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
