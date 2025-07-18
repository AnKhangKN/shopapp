import 'package:dio/dio.dart';
import '../models/product_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserServices {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: dotenv.env['API_BASE_URL']!,
    // đổi thành IP hoặc domain thực tế nếu dùng mobile
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  Future<Response> loginUser({
    required String email,
    required String password,
  }) async {
    final data = {
      'email': email,
      'password': password,
    };

    try {
      final res = await _dio.post('/user/login', data: data);
      return res;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Đăng nhập thất bại!');
      } else {
        throw Exception('Không thể kết nối đến server!');
      }
    }
  }

  Future<Response> registerUser({
    required String email,
    required String password,
    String? userName,
    String? image,
  }) async {
    final data = {
      'email': email,
      'password': password,
      'userName': userName ?? "Khách hàng",
      'image': image,
    };

    try {
      final res = await _dio.post('/user/register', data: data);
      return res;
    } on DioException catch (e) {
      // Nếu có response từ server (vd: email đã tồn tại)
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Đăng ký thất bại!');
      } else {
        throw Exception('Không thể kết nối đến server!');
      }
    }
  }
}