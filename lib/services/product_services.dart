import 'package:dio/dio.dart';
import '../models/product_models.dart';

class ProductServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8001/api',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _dio.get('/shared/products');

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
}
