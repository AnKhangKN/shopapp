import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/models/product_models.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  String formatCurrency(num value) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.images.isNotEmpty ? product.images.first : '';
    final salePrice = product.sale?.price ?? 0;
    final originalPrice = product.details.isNotEmpty
        ? product.details.first.price
        : 0;
    final isOnSale = salePrice > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: imageUrl.isNotEmpty
                    ? Image.network(imageUrl, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.image, size: 40)),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: isOnSale
                  ? Row(
                      children: [
                        Flexible(
                          child: Text(
                            formatCurrency(salePrice),
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            formatCurrency(originalPrice),
                            style: const TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      formatCurrency(originalPrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
