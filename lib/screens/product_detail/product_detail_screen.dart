import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/constants/app_colors.dart';
import 'package:shopapp/models/cart_models.dart';
import 'package:shopapp/models/product_detail_models.dart';
import 'package:shopapp/models/product_models.dart';
import 'package:shopapp/models/wish_list_models.dart';
import 'package:shopapp/screens/product_detail/button_custom/button_custom.dart';
import 'package:shopapp/services/cart_services.dart';
import 'package:shopapp/services/product_services.dart';
import 'package:shopapp/services/wish_list_services.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final String? from;

  const ProductDetailScreen({super.key, required this.productId, this.from});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _productServices = ProductServices();
  final cartService = CartService();
  final _wishListServices = WishListServices();

  Product? _product;
  List<ProductDetail> _details = [];

  int _selectedImageIndex = 0;
  late PageController _pageController;
  final _formatter = NumberFormat("#,###", "vi_VN");

  List<String> sizes = [];
  List<String> colors = [];
  String _selectedSize = '';
  String _selectedColor = '';
  int quantity = 1;
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );
  bool isWished = false;
  bool _loading = true;
  String? _error;

  // final buttonLabel = isWished ? "Đã có trong yêu thích" : "Thêm vào yêu thích";

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedImageIndex);
    fetchProductDetail();
    _checkWishlistStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchProductDetail() async {
    try {
      final result = await _productServices.getProductDetail(widget.productId);
      final details = result.details ?? [];

      final uniqueSizes = details
          .map((d) => d.size)
          .whereType<String>()
          .toSet()
          .toList();
      final initialSize = uniqueSizes.isNotEmpty ? uniqueSizes.first : '';
      final filteredColors = details
          .where((d) => d.size == initialSize)
          .map((d) => d.color)
          .whereType<String>()
          .toSet()
          .toList();

      setState(() {
        _product = result;
        _details = details;
        sizes = uniqueSizes;
        colors = filteredColors;
        _selectedSize = initialSize;
        _selectedColor = filteredColors.isNotEmpty ? filteredColors.first : '';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  ProductDetail? get selectedDetail {
    if (_selectedSize.isNotEmpty) {
      return _details.firstWhere(
        (d) => d.size == _selectedSize && d.color == _selectedColor,
        orElse: () => ProductDetail(color: '', price: 0, quantity: 0),
      );
    } else if (_selectedColor.isNotEmpty) {
      return _details.firstWhere(
        (d) => d.color == _selectedColor,
        orElse: () => ProductDetail(color: '', price: 0, quantity: 0),
      );
    }
    return null;
  }

  Future<void> _addToCart() async {
    final payload = CartItem(
      productId: _product!.id,
      productName: _product!.productName,
      productImage: _product!.images.isNotEmpty ? _product!.images[0] : null,
      size: _selectedSize,
      color: _selectedColor,
      price: selectedDetail!.price,
      quantity: quantity,
    );

    final success = await cartService.addToCart(item: payload);
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã thêm vào giỏ hàng')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Thêm vào giỏ hàng thất bại')));
    }
  }

  Future<void> _checkWishlistStatus() async {
    try {
      final exists = await _wishListServices.checkWishItem(widget.productId);
      setState(() {
        isWished = exists;
      });
    } catch (e) {
      print("Lỗi kiểm tra wishlist: $e");
    }
  }

  Future<void> _addWishList(String productId, String name, String image) async {
    try {
      final res = await _wishListServices.addWishList(productId, name, image);

      if (res.statusCode == 200) {

        setState(() {
          isWished = true; // Cập nhật UI
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã thêm vào danh sách yêu thích')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Thêm vào yêu thích thất bại')));
      }
    } catch (error) {
      print("Lỗi thêm yêu thích: $error");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading)
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_error != null)
      return Scaffold(body: Center(child: Text('Lỗi: $_error')));
    if (_product == null)
      return Scaffold(body: Center(child: Text('Không tìm thấy sản phẩm')));

    final product = _product!;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName),
        leading: IconButton(
          icon: Icon(FeatherIcons.chevronLeft),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/product');
            }
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.images.isNotEmpty)
              SizedBox(
                height: 300,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: product.images.length,
                  onPageChanged: (index) =>
                      setState(() => _selectedImageIndex = index),
                  itemBuilder: (context, index) {
                    final imageUrl =
                        '${dotenv.env['SHOW_IMAGE_BASE_URL']}/product/${product.images[index]}';
                    return Image.network(imageUrl, fit: BoxFit.cover);
                  },
                ),
              ),

            const SizedBox(height: 8),
            if (product.images.length > 1)
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: product.images.length,
                  itemBuilder: (context, index) {
                    final imageUrl =
                        '${dotenv.env['SHOW_IMAGE_BASE_URL']}/product/${product.images[index]}';
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = index;
                          _pageController.jumpToPage(index);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedImageIndex == index
                                ? Colors.blue
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Image.network(
                          imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 12),
            Text(
              product.productName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text('Giá: ${_formatter.format(selectedDetail?.price ?? 0)} đ'),
            const SizedBox(height: 8),
            Text('Tồn kho: ${selectedDetail?.quantity ?? 0}'),
            const SizedBox(height: 12),

            if (sizes.isNotEmpty)
              Wrap(
                spacing: 8,
                children: sizes.map((size) {
                  return ChoiceChip(
                    label: Text(size),
                    selected: _selectedSize == size,
                    onSelected: (_) {
                      final filtered = _details
                          .where((d) => d.size == size)
                          .map((d) => d.color)
                          .whereType<String>()
                          .toSet()
                          .toList();

                      setState(() {
                        _selectedSize = size;
                        colors = filtered;
                        _selectedColor = colors.isNotEmpty ? colors.first : '';
                      });
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 12),

            if (colors.isNotEmpty)
              Wrap(
                spacing: 8,
                children: colors.map((color) {
                  return ChoiceChip(
                    label: Text(color),
                    selected: _selectedColor == color,
                    onSelected: (_) {
                      setState(() => _selectedColor = color);
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),

            Row(
              children: [
                IconButton(
                  onPressed: quantity > 1
                      ? () => setState(() {
                          quantity--;
                          _quantityController.text = quantity.toString();
                        })
                      : null,
                  icon: Icon(Icons.remove),
                ),
                SizedBox(
                  width: 40,
                  child: TextField(
                    controller: _quantityController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final val = int.tryParse(value);
                      if (val != null &&
                          val > 0 &&
                          val <= (selectedDetail?.quantity ?? 0)) {
                        quantity = val;
                      } else {
                        _quantityController.text = quantity.toString();
                      }
                    },
                  ),
                ),
                IconButton(
                  onPressed: quantity < (selectedDetail?.quantity ?? 1)
                      ? () => setState(() {
                          quantity++;
                          _quantityController.text = quantity.toString();
                        })
                      : null,
                  icon: Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 20),
            ButtonCustom(onPressed: _addToCart, label: "Thêm vào giỏ hàng"),
            const SizedBox(height: 12),

            Opacity(
              opacity: isWished ? 0.6 : 1.0, // Mờ khi đã có
              child: ButtonCustom(
                label: isWished
                    ? "Đã có trong yêu thích"
                    : "Thêm vào yêu thích",
                backgroundColor: isWished ? Colors.grey[100]! : Colors.white,
                foregroundColor: AppColors.textPrimary,
                onPressed: () {
                  isWished
                      ? null
                      : _addWishList(
                          product.id,
                          product.productName,
                          product.images[0],
                        );
                },
              ),
            ),

            const SizedBox(height: 30),
            Text(product.description ?? 'Không có mô tả'),
          ],
        ),
      ),
    );
  }
}
