import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/models/address_models.dart';

class CheckoutServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL']!,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<ShippingAddress>> getShippingAddresses() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Chưa đăng nhập');

      final response = await _dio.get(
        '/user/shippingAddress',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['shippingAddress'];

        if (data is List) {
          return data.map((item) => ShippingAddress.fromJson(item)).toList();
        } else {
          throw Exception('Dữ liệu shippingAddress không đúng định dạng');
        }
      } else {
        throw Exception('Lỗi lấy địa chỉ giao hàng: ${response.statusMessage}');
      }
    } catch (e) {
      print('Lỗi khi lấy shippingAddress: $e');
      rethrow;
    }
  }

  Future<void> addAddress({required String phone, required String address, required String city,}) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Chưa đăng nhập');

      final response = await _dio.post(
        '/user/shippingAddress',
        data: {'phone': phone, 'address': address, 'city': city},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Thêm địa chỉ thành công');
      } else {
        throw Exception('Không thể thêm địa chỉ: ${response.statusMessage}');
      }
    } catch (e) {
      print('Lỗi thêm địa chỉ: $e');
      rethrow;
    }
  }

  Future<void> createOrder({required Map<String, dynamic> shippingAddress, required List<Map<String, dynamic>> items, required String orderNote, required double totalPrice, required int shippingPrice, required String paymentMethod,}) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Chưa đăng nhập');

      final data = {
        "shippingAddress": shippingAddress,
        "items": items,
        "orderNote": orderNote,
        "totalPrice": totalPrice,
        "shippingPrice": shippingPrice,
        "paymentMethod": paymentMethod,
      };

      final response = await _dio.post(
        '/user/orders',
        data: data,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Tạo đơn hàng thành công');
      } else {
        throw Exception('Không thể tạo đơn hàng: ${response.statusMessage}');
      }
    } catch (error) {
      print('Lỗi tạo đơn hàng: $error');
      rethrow;
    }
  }

  Future<void> deleteAddress (String phone, String address, String city) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Chưa đăng nhập');

      final response = await _dio.delete(
        '/user/shippingAddress',
        data: {
          'phone': phone,
          'address': address,
          'city': city
        }, options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        })
      );

      if (response.statusCode == 200) {
        print("Đã xóa địa chỉ thành công");
      } else {
        throw Exception('Không thể tạo đơn hàng: ${response.statusMessage}');
      }

    } catch (error) {
      print('Lỗi xóa địa chỉ: $error');
      rethrow;
    }
  }
}
