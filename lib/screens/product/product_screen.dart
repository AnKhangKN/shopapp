import 'package:flutter/material.dart';
import 'package:shopapp/models/product_models.dart';
import 'package:shopapp/services/product_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductScreen extends StatefulWidget {

  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final baseImageUrl = dotenv.env['SHOW_IMAGE_BASE_URL'];
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
      appBar: AppBar(title: Text('Danh sách sản phẩm')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final p = _products[index];
          final imageUrl = p.images.isNotEmpty
              ? '$baseImageUrl/${p.images[0]}'
              : null;
          final price = p.details.isNotEmpty ? p.details[0].price : 0;

          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: imageUrl != null
                  ? Image.network(imageUrl, width: 60, fit: BoxFit.cover)
                  : Icon(Icons.image_not_supported),
              title: Text(p.productName),
              subtitle: Text('Giá: ${price.toString()} VNĐ\nTrạng thái: ${p.status} \nLượt bán: ${p.soldCount}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
