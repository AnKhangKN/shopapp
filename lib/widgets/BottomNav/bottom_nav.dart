import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

class BottomNav extends StatelessWidget {
  final Widget child;

  const BottomNav({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/product')) return 1;
    if (location.startsWith('/wish')) return 2;
    if (location.startsWith('/cart')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/'); // Home
        break;
      case 1:
        context.go('/product'); // Cart
        break;
      case 2:
        context.go('/wish'); // Cart
        break;
      case 3:
        context.go('/cart'); // Product
        break;
      case 4:
        context.go('/profile'); // Profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.home),
            // activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.search),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.heart),
            label: 'Wish',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.shoppingBag),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.user),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
