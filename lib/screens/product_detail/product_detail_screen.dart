import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/constants/app_colors.dart';
import 'package:shopapp/services/product_services.dart';
import 'package:shopapp/models/product_models.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  final String? from;

  const ProductDetailScreen({super.key, required this.productId, this.from});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: ProductServices().getProductDetail(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Lỗi: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Không tìm thấy sản phẩm')),
          );
        }

        final product = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                if (from != null && from!.isNotEmpty) {
                  context.go(from!);
                } else {
                  context.go('/');
                }
              },
              icon: const Icon(FeatherIcons.chevronLeft),
            ),
            title: Text(
              product.productName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
              ),
            ),
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
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Tên sản phẩm: ${product.productName}'),
          ),
        );
      },
    );
  }

}
