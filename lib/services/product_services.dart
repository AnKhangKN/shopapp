import 'package:dio/dio.dart';
import '../models/product_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductServices {
  Future<List<Product>> getAllProducts() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL']!,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
      ),
    );

    try {
      final response = await dio.get('/shared/products');

      if (response.statusCode == 200) {
        final products = (response.data['products'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
        return products;
      } else {
        throw Exception('Lỗi lấy sản phẩm: ${response.statusMessage}');
      }
    } catch (error) {
      throw Exception('Lỗi kết nối: $error');
    }
  }

  Future<Product> getProductDetail(String productId) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL']!,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
      ),
    );

    try {
      final response = await dio.get('/shared/products/$productId');

      if (response.statusCode == 200) {
        final productJson = response.data['product']; // Giả sử backend trả về { product: {...} }
        return Product.fromJson(productJson);
      } else {
        throw Exception('Lỗi lấy sản phẩm: ${response.statusMessage}');
      }
    } catch (error) {
      throw Exception('Lỗi kết nối: $error');
    }
  }

}
