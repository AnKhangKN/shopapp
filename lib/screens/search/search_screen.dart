import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';

class SearchScreen extends StatelessWidget {
  final String? from;

  const SearchScreen({super.key, this.from}); // Thêm this.from

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
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
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      // Nếu có from thì quay lại from, ngược lại về trang chủ
                      if (from != null && from!.isNotEmpty) {
                        context.go(from!);
                      } else {
                        context.go('/');
                      }
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
