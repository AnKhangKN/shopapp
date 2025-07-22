import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/models/product_models.dart';
import 'package:shopapp/screens/product/product_item_card/product_item_card.dart';
import 'package:shopapp/services/product_services.dart';
import 'category_header_delegate/category_header_delegate.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _productServices = ProductServices();
  List<Product> _allProducts = [];
  List<Product> _products = [];
  List<String> _categories = ["Tất cả"];
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

      final Map<String, String> categoryMap = {};
      for (var p in result) {
        final original = p.category?.trim();
        final normalized = original?.toLowerCase();
        if (original != null && original.isNotEmpty && normalized != null) {
          categoryMap[normalized] = original;
        }
      }

      setState(() {
        _allProducts = result;
        _products = result;
        _categories = ["Tất cả", ...categoryMap.values.toSet()];
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
      _products = (category == "Tất cả")
          ? _allProducts
          : _allProducts
          .where((product) =>
      product.category?.toLowerCase() == category.toLowerCase())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? const Center(child: Text("Không có sản phẩm nào."))
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 100,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final top = constraints.biggest.height;
                final showCenterTitle = top < 120;

                return FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  // centerTitle: showCenterTitle,
                  titlePadding: showCenterTitle
                      ? const EdgeInsets.only(left: 16.0, bottom: 16.0)
                      : const EdgeInsets.only(left: 16.0, bottom: 16.0),
                  title: const Text(
                    'Sản phẩm',
                    style: TextStyle(fontSize: 18, ),
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(FeatherIcons.search),
                onPressed: () {
                  final currentLocation = GoRouter.of(context)
                      .routerDelegate.currentConfiguration.uri
                      .toString();
                  context.go('/search?from=$currentLocation');
                },
              ),
            ],
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: CategoryHeaderDelegate(
              selectedCategory: _selectedCategory,
              onCategorySelected: filterProducts,
              categories: _categories,
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                    ProductItemCard(product: _products[index]),
                childCount: _products.length,
              ),
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
