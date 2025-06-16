import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/models/product_models.dart';
import 'package:shopapp/screens/product/product_item_card/product_item_card.dart';
import 'package:shopapp/services/product_services.dart';
import '../../widgets/CustomAppBar/CustomAppBar.dart';
import 'category_header_delegate/category_header_delegate.dart';

// --- Widget chính ---
class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _productServices = ProductServices();
  List<Product> _allProducts = [];
  List<Product> _products = [];
  bool _loading = true;
  String _selectedCategory = "Tất cả";

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      final result = await _productServices.getAllProducts();
      setState(() {
        _allProducts = result;
        _products = result;
        _loading = false;
      });
    } catch (e) {
      print('Lỗi: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  void filterProducts(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == "Tất cả") {
        _products = _allProducts;
      } else {
        _products = _allProducts
            .where(
              (product) =>
                  product.category?.toLowerCase() == category.toLowerCase(),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.search),
            onPressed: () {
              context.go('/search');
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? const Center(child: Text("Không có sản phẩm nào."))
          : CustomScrollView(
              slivers: [
                // Sliver: tiêu đề "Danh sách sản phẩm"
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 16,
                      bottom: 12,
                    ),
                    child: Text(
                      "Danh sách sản phẩm",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Sliver: Header lọc danh mục
                SliverPersistentHeader(
                  pinned: true,
                  delegate: CategoryHeaderDelegate(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: filterProducts,
                  ),
                ),
                // Sliver: Grid sản phẩm
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ProductItemCard(product: _products[index]);
                    }, childCount: _products.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.6,
                        ),
                  ),
                ),
              ],
            ),
    );
  }
}
