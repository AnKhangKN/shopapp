import 'package:dio/dio.dart';
import 'package:shopapp/models/token_storage.dart';
import '../models/product_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/models/user_model.dart';

class UserServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL']!,
      // đổi thành IP hoặc domain thực tế nếu dùng mobile
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Response> loginUser({
    required String email,
    required String password,
  }) async {
    final data = {'email': email, 'password': password};

    try {
      final res = await _dio.post('/user/login', data: data);
      print("Phản hồi từ backend: ${res.data}");
      final token = res.data['token'];

      if (token != null && token is String && token.isNotEmpty) {
        await TokenStorage.setToken(token);
        print("Token vừa lưu: $token");
      } else {
        print("Token không tồn tại hoặc không hợp lệ: $token");
      }
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

  Future<UserModel> getUserInfo({required String accessToken}) async {
    try {
      final res = await _dio.get(
        '/user/get-user-info',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      final data = res.data['data'];
      print("Token đang dùng để gọi getUserInfo: $data");
      return UserModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Lấy thông tin thất bại!',
        );
      } else {
        throw Exception('Không thể kết nối đến server!');
      }
    }
  }

  Future<void> sendOtp(String email) async {
    await _dio.post('/user/forgot-password', data: {'email': email});
  }

  Future<void> verifyOtp(String email, String otp) async {
    await _dio.post('/user/verify-otp', data: {'email': email, 'otp': otp});
  }

  Future<void> resetPassword(String email, String newPassword) async {
    await _dio.post(
      '/user/reset-password',
      data: {'email': email, 'newPassword': newPassword},
    );
  }
}
