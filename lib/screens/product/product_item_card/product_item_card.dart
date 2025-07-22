import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/models/product_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../constants/app_colors.dart';

class ProductItemCard extends StatelessWidget {
  final Product product;

  const ProductItemCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseImageUrl = dotenv.env['SHOW_IMAGE_BASE_URL'];
    final imageUrl = product.images.isNotEmpty
        ? '$baseImageUrl/${product.images[0]}'
        : null;
    final price = product.details.isNotEmpty ? product.details[0].price : 0;

    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          final currentLocation = GoRouter.of(
            context,
          ).routerDelegate.currentConfiguration.uri.toString();
          context.go('/product/${product.id}?from=$currentLocation');
        },

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  imageUrl != null
                      ? Image.network(
                          imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox(
                          height: 180,
                          child: Center(
                            child: Icon(Icons.image_not_supported, size: 60),
                          ),
                        ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Xử lý thêm vào wishlist
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          FeatherIcons.heart,
                          size: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                product.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                product.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // style: const TextStyle(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Giá: $price VNĐ',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
