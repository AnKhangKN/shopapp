import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/models/wish_list_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WishListServices {
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

  Future<Response> addWishList(
    String productId,
    String productName,
    String productImg,
  ) async {
    try {
      final token = await _getToken();

      final response = await _dio.post(
        '/user/wishes',
        data: {
          'productId': productId,
          'productName': productName,
          'productImg': productImg,
        },
        options: Options(headers: {'Authorization': 'Bearer ${token}'}),
      );

      return response;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<List<WishList>> getAllWishList() async {
    try {
      final token = await _getToken();

      final res = await _dio.get(
        '/user/wishes',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> data = res.data['wishlist'];
      return data.map((json) => WishList.fromJson(json)).toList();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<Response> deleteWishItem(String productId) async {
    try {
      final token = await _getToken();

      final response = await _dio.delete(
        '/user/wishes',
        data: {
          'productId': productId
        },
        options: Options(headers: {'Authorization': 'Bearer ${token}'}),
      );

      return response;
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
