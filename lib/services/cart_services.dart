import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_models.dart';

class CartService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL']!,
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Gọi API thêm sản phẩm vào giỏ hàng
  Future<bool> addToCart({ required CartItem item }) async {
    final token = await _getToken();

    if (token == null) {
      print('Token không tồn tại!');
      return false;
    }

    try {
      final response = await _dio.post(
        '/user/carts',
        data:  item.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data!['message'] == 'Thêm sản phẩm vào giỏ hàng thành công!') {
        return true;
      } else {
        print('Add to cart failed: ${response.data!['message']}');
        return false;
      }
    } catch (e) {
      print('Add to cart error: $e');
      return false;
    }
  }

  Future<List<CartItem>> getCartItem() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Chưa đăng nhập');

      final response = await _dio.get(
        '/user/carts',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data['carts'];

        // Tự động phát hiện cấu trúc
        if (data is Map<String, dynamic> && data.containsKey('items')) {
          final items = data['items'] as List<dynamic>;
          return items.map((item) => CartItem.fromJson(item)).toList();
        } else if (data is List) {
          return data.map((item) => CartItem.fromJson(item)).toList();
        } else {
          throw Exception('Dữ liệu carts không đúng định dạng');
        }
      } else {
        throw Exception('Lỗi lấy giỏ hàng: ${response.statusMessage}');
      }
    } catch (e) {
      print('Get cart item error: $e');
      rethrow;
    }
  }

  Future<void> updateItemQuantity(String productId, String color, String size, int quantity) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Chưa đăng nhập');

      final response = await _dio.put(
        '/user/carts/updateQuantity',
        data: {
          "productId": productId,
          "color": color,
          "size": size,
          "quantity": quantity,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        print("Cập nhật thành công");
      } else {
        throw Exception('Lỗi cập nhật số lượng: ${response.statusCode}');
      }
    } catch (e) {
      print("Lỗi updateItemQuantity: $e");
      rethrow;
    }
  }

  Future<void> deleteCartItem (String productId, String color, String size) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Chưa đăng nhập');

      final response = await _dio.delete(
        '/user/carts/deleteItems',
        data: {
          'productId': productId,
          'color': color,
          'size': size
        }, options: Options( headers: {
          'Authorization': 'Bearer $token',
        })
      );

      if (response.statusCode == 200) {
        print("Xóa sản phẩm thành công!");
      } else {
        throw Exception('Lỗi cập nhật số lượng: ${response.statusCode}');
      }

    } catch (error) {
      print("Error ${error}");
      rethrow;
    }
  }

}
