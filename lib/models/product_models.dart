import 'package:shopapp/models/product_detail_models.dart';
import 'package:shopapp/models/sale_models.dart';

class Product {
  final String id;
  final String productName;
  final String? description;
  final String category;
  final List<String> images;
  final List<ProductDetail> details;
  final String status;
  final Sale? sale;
  final int soldCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.productName,
    this.description,
    required this.category,
    required this.images,
    required this.details,
    required this.status,
    this.sale,
    required this.soldCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      productName: json['productName'],
      description: json['description'],
      category: json['category'],
      images: List<String>.from(json['images']),
      details: (json['details'] as List)
          .map((e) => ProductDetail.fromJson(e))
          .toList(),
      status: json['status'],
      sale: json['sale'] != null ? Sale.fromJson(json['sale']) : null,
      soldCount: json['soldCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
