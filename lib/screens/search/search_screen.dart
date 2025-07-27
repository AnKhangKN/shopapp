import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_colors.dart';
import '../../models/product_models.dart';
import '../../services/product_services.dart';

class SearchScreen extends StatefulWidget {
  final String? from;

  const SearchScreen({super.key, this.from});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductServices _productServices = ProductServices();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _productServices.getAllProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products.take(5).toList(); // chỉ lấy 5 sản phẩm đầu tiên
        _isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi tải sản phẩm: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String keyword) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        if (keyword.isEmpty) {
          _filteredProducts = _allProducts;
        } else {
          _filteredProducts = _allProducts
              .where((product) =>
          product.productName.toLowerCase().contains(keyword.toLowerCase()) ?? false)
              .toList();
        }
      });
    });
  }

  void _handleCancel() {
    if (context.canPop()) {
      context.pop();
    } else if (widget.from != null && widget.from!.isNotEmpty) {
      context.go(widget.from!);
    } else {
      context.go('/');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Input
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm sản phẩm...",
                          prefixIcon: const Icon(FeatherIcons.search),
                          filled: true,
                          fillColor: AppColors.grayLow,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _handleCancel,
                    child: const Text("Cancel"),
                  )
                ],
              ),
            ),

            // Result list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_searchController.text.isEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Đề xuất cho bạn",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _allProducts.length >= 5 ? 5 : _allProducts.length,
                        itemBuilder: (context, index) {
                          final product = _allProducts[index];
                          return ListTile(
                            title: Text(product.productName ?? ''),
                            subtitle: Text(product.category ?? ''),
                            onTap: () {
                              context.push('/product/${product.id}');
                            },
                          );
                        },
                      ),
                    ),
                  ] else if (_filteredProducts.isEmpty) ...[
                    const Expanded(
                      child: Center(
                        child: Text("Không tìm thấy sản phẩm nào."),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return ListTile(
                            title: Text(product.productName ?? "Không có tên"),
                            subtitle: Text(product.category ?? ''),
                            onTap: () {
                              context.push('/product/${product.id}');
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
