import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shopapp/widgets/CustomAppBar/CustomAppBar.dart';

class WishScreen extends StatelessWidget {
  const WishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.search),
            onPressed: () {
              // xử lý tìm kiếm
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to Wish!'),
      ),
    );
  }
}
