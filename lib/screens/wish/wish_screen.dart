import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WishScreen extends StatelessWidget {
  const WishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu danh sách sản phẩm yêu thích (mock)
    final List<String> wishList = [
      "Sản phẩm 1",
      "Sản phẩm 2",
      "Sản phẩm 3",
      "Sản phẩm 4",
      "Sản phẩm 5",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Yêu thích"),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed('search'),
            icon: const Icon(Icons.search_sharp),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: wishList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cột
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75, // Tỉ lệ chiều cao / rộng
            ),
            itemBuilder: (context, index) {
              final product = wishList[index];

              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Text(
                    product,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
