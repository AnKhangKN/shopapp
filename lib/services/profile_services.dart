import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shopapp/models/user_model.dart';

class ProfileServices {
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

  Future<Response> updateProfileInfo(String userName) async {
    final token = await _getToken();

    final response = await _dio.put(
      "/user/updateUserName",
      data: {"userName": userName},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return response;
  }

  Future<Response> updateAvatar(File imageFile) async {
    final token = await _getToken();
    final String fileName = imageFile.path.split('/').last;

    // Xác định contentType MIME
    MediaType contentType;
    if (fileName.toLowerCase().endsWith('.png')) {
      contentType = MediaType('image', 'png');
    } else if (fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.jpeg')) {
      contentType = MediaType('image', 'jpeg');
    } else {
      throw Exception('Định dạng ảnh không hợp lệ');
    }

    FormData formData = FormData.fromMap({
      'avatarImage': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: contentType,
      ),
    });

    final response = await _dio.post(
      "/user/uploadAvatar",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    return response;
  }

  Future<UserModel> getDetail() async {
    try {
      final token = await _getToken();

      final response = await _dio.get(
        '/user/users',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        // Giả sử bạn có phương thức fromJson trong UserModel
        print(response.data['user']);

        return UserModel.fromJson(response.data['user']);

      } else {
        throw Exception("Failed to fetch user: ${response.statusCode}");
      }
    } catch (error) {
      print("Lỗi khi gọi API getDetail: $error");
      throw Exception("Lỗi khi lấy thông tin người dùng");
    }
  }

}
