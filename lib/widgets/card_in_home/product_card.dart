import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/models/product_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseImageUrl = dotenv.env['SHOW_IMAGE_BASE_URL'];
    final imageUrl = product.images.isNotEmpty
        ? '$baseImageUrl/${product.images[0]}'
        : null;
    final price = product.details.isNotEmpty ? product.details[0].price : 0;

    return SizedBox(
      width: 160,
      child: Material(
        color: Colors.white,
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            final currentLocation = GoRouter.of(context)
                .routerDelegate.currentConfiguration.uri.toString();
            context.go('/product/${product.id}?from=$currentLocation');
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(12), // ĐỒNG BỘ bo góc
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: imageUrl != null
                    ? Image.network(
                  imageUrl,
                  height: 100, // Giảm chiều cao cho gọn
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : const SizedBox(
                  height: 100,
                  child: Center(child: Icon(Icons.image_not_supported, size: 40)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  product.category,
                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '$price đ',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
