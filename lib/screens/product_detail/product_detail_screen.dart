import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/constants/app_colors.dart';
import 'package:shopapp/services/product_services.dart';
import 'package:shopapp/models/product_models.dart';
import 'package:shopapp/models/product_detail_models.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final String? from;

  const ProductDetailScreen({super.key, required this.productId, this.from});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  final _productServices = ProductServices();
  Product? _product;
  List<ProductDetail> _details = [];

  bool _loading = true;
  String? _error;

  List<String> sizes = [];
  List<String> colors = [];
  String _selectedSize = '';
  String _selectedColor = '';

  late PageController _pageController;
  final _formatter = NumberFormat("#,###", "vi_VN");

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedImageIndex);
    fetchProductDetail();
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
      final filteredColors = uniqueSizes.isNotEmpty
          ? details
                .where((d) => d.size == initialSize)
                .map((d) => d.color)
                .whereType<String>()
                .toSet()
                .toList()
          : details.map((d) => d.color).whereType<String>().toSet().toList();

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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Lỗi: $_error')),
      );
    }

    if (_product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Không tìm thấy sản phẩm')),
      );
    }

    final product = _product!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (widget.from != null && widget.from!.isNotEmpty) {
              context.go(widget.from!);
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
          style: const TextStyle(color: AppColors.textPrimary),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.images.isNotEmpty)
              SizedBox(
                height: 350,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: product.images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final imageUrl =
                        '${dotenv.env['SHOW_IMAGE_BASE_URL']}/${product.images[index]}';
                    return Image.network(imageUrl, fit: BoxFit.cover);
                  },
                ),
              )
            else
              const SizedBox(
                height: 180,
                child: Center(child: Icon(Icons.image_not_supported, size: 60)),
              ),

            if (product.images.length > 1)
              Container(
                margin: const EdgeInsets.only(top: 12),
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: product.images.length,
                  itemBuilder: (context, index) {
                    final imageUrl =
                        '${dotenv.env['SHOW_IMAGE_BASE_URL']}/${product.images[index]}';
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                        _pageController.jumpToPage(index);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedImageIndex == index
                                ? AppColors.textPrimary
                                : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(product.category, style: const TextStyle(fontSize: 14)),

            const SizedBox(height: 12),
            if (selectedDetail != null && selectedDetail!.price > 0) ...[
              Text(
                'Giá: ${_formatter.format(selectedDetail!.price)}đ',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Tồn kho: ${selectedDetail!.quantity}',
                style: const TextStyle(fontSize: 14),
              ),
            ] else
              const Text(
                'Vui lòng chọn màu (và kích thước nếu có)',
                style: TextStyle(color: Colors.grey),
              ),

            const SizedBox(height: 16),

            if (sizes.isNotEmpty) ...[
              const Text(
                'Chọn kích cỡ:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: sizes.map((size) {
                  return ChoiceChip(
                    label: Text(size),
                    selected: _selectedSize == size,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedSize = size;
                        final filteredColors = _details
                            .where((d) => d.size == size)
                            .map((d) => d.color)
                            .whereType<String>()
                            .toSet()
                            .toList();

                        colors = filteredColors;
                        _selectedColor = colors.isNotEmpty ? colors.first : '';
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            const Text(
              'Chọn màu:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (colors.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: colors.map((color) {
                  return ChoiceChip(
                    label: Text(color),
                    selected: _selectedColor == color,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                  );
                }).toList(),
              )
            else
              const Text(
                'Không có màu cho kích cỡ này',
                style: TextStyle(color: Colors.red),
              ),

            // add to bag
            SizedBox(
              width: double.infinity, // Full width
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textPrimary,
                  foregroundColor: AppColors.colorWhite,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                onPressed: () {
                  // TODO: thêm logic thêm vào giỏ hàng
                },
                child: const Text(
                  "Thêm vào giỏ hàng",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // add to wish list
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: ButtonTheme(child: Text("Thêm vào yêu thích")),
            ),

            Text(
              product.description ?? 'Chưa có mô tả',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
