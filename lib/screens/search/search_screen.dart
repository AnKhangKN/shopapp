import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/constants/app_colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // tránh tai thỏ, notch
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50, // chiều cao TextField
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Nhập sản phẩm cần tìm ...",
                          prefixIcon: const Icon(FeatherIcons.search),
                          filled: true,
                          fillColor: AppColors.grayLow,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // khoảng cách giữa TextField và nút
                  TextButton(
                    onPressed: () {
                      // Xử lý khi bấm Cancel (ví dụ: quay về màn trước)
                      context.go('/');
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
            // TODO: thêm phần hiển thị kết quả tìm kiếm
          ],
        ),
      ),
    );
  }
}
