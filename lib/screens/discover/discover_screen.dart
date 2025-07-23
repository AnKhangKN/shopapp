import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/screens/discover/about/structure_26.dart';

class DiscoverScreen extends StatelessWidget {
  final String contentType;

  const DiscoverScreen({super.key, required this.contentType});

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> contentWidgets = {
      'structure26': const Structure26(),
    };

    final Widget? contentWidget = contentWidgets[contentType.toLowerCase()];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body:
          contentWidget ?? const Center(child: Text('Không tìm thấy nội dung')),
    );
  }
}
