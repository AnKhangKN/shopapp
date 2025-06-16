import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/models/product_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      child: InkWell(
        onTap: () {
          context.go('/'); // hoặc '/product/${product.id}'
        },

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image_not_supported, size: 100),
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
                'Giá: $price VNĐ',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Đã bán: ${product.soldCount}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
