import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shopapp/models/product_models.dart';
import 'package:shopapp/screens/product/product_item_card/product_item_card.dart';
import 'package:shopapp/services/product_services.dart';

import '../../widgets/CustomAppBar/CustomAppBar.dart';

class ProductScreen extends StatefulWidget {

  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _productServices = ProductServices();
  List<Product> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      final result = await _productServices.getAllProducts();
      setState(() {
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
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: _products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 sản phẩm mỗi hàng
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.6, // Tùy chỉnh để cân đối chiều cao/chiều rộng
          ),
          itemBuilder: (context, index) {
            return ProductItemCard(product: _products[index]); // viết trong widget
          },
        ),
      ),
    );
  }
}
