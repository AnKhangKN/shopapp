import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shopapp/services/wish_list_services.dart';

import '../../../constants/app_colors.dart';
import '../../../models/product_models.dart';

class ProductItemCard extends StatefulWidget {
  final Product product;

  const ProductItemCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductItemCard> createState() => _ProductItemCardState();
}

class _ProductItemCardState extends State<ProductItemCard> {
  bool isWished = false; // trạng thái yêu thích
  final _wishListServices = WishListServices();

  @override
  void initState() {
    super.initState();
    _checkWishlist();
  }

  Future<void> _checkWishlist() async {
    final exists = await _wishListServices.checkWishItem(widget.product.id);
    setState(() {
      isWished = exists;
    });
  }

  Future<void> _toggleWishlist() async {
    setState(() {
      isWished = !isWished;
    });

    // TODO: Gọi API thêm hoặc xóa khỏi wishlist
    try {
      if (isWished) {
        // await WishlistService().addToWishlist(widget.product.id);
        await _wishListServices.addWishList(
          widget.product.id,
          widget.product.productName,
          widget.product.images[0],
        );
        print("Đã thêm vào wishlist: ${widget.product.productName}");
      } else {
        await _wishListServices.deleteWishItem(widget.product.id);
        print("Đã xóa khỏi wishlist: ${widget.product.productName}");
      }
    } catch (e) {
      print("Lỗi wishlist: $e");
      // rollback UI nếu cần
      setState(() {
        isWished = !isWished;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseImageUrl = dotenv.env['SHOW_IMAGE_BASE_URL'];
    final imageUrl = widget.product.images.isNotEmpty
        ? '$baseImageUrl/product/${widget.product.images[0]}'
        : null;
    final price = widget.product.details.isNotEmpty
        ? widget.product.details[0].price
        : 0;
    final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");

    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          final currentLocation = GoRouter.of(
            context,
          ).routerDelegate.currentConfiguration.uri.toString();
          context.go('/product/${widget.product.id}?from=$currentLocation');
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
                      onTap: _toggleWishlist,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          isWished ? Icons.favorite : Icons.favorite_border,
                          color: isWished ? Colors.red : AppColors.textPrimary,
                          size: 22,
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
                widget.product.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                widget.product.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Giá: ${formatter.format(price)}đ',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
