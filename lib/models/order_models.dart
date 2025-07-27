import 'address_models.dart';
import 'order_item_models.dart';

class Order {
  final String id;
  final ShippingAddress shippingAddress;
  final List<OrderItem> items;
  final String orderNote;
  final int totalPrice;
  final int shippingPrice;
  final String paymentMethod;
  final bool isPaid;
  final DateTime? paidAt; // ✅ sửa tại đây
  final String status;
  final String cancelReason;
  final DateTime? deliveredAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.shippingAddress,
    required this.items,
    required this.orderNote,
    required this.totalPrice,
    required this.shippingPrice,
    required this.paymentMethod,
    required this.isPaid,
    required this.paidAt, // ✅ nullable
    required this.status,
    required this.cancelReason,
    this.deliveredAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    print("⚠️ paidAt raw value: ${json['paidAt']}");
    print("⚠️ createdAt raw value: ${json['createdAt']}");
    print("⚠️ updatedAt raw value: ${json['updatedAt']}");
    try {
      return Order(
        id: json['_id'],
        shippingAddress: ShippingAddress.fromJson(json['shippingAddress']),
        items: (json['items'] as List)
            .map((e) => OrderItem.fromJson(e))
            .toList(),
        orderNote: json['orderNote'] ?? '',
        totalPrice: json['totalPrice'],
        shippingPrice: json['shippingPrice'],
        paymentMethod: json['paymentMethod'],
        isPaid: json['isPaid'],
        paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
        deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt']) : null, // ✅ THÊM DÒNG NÀY
        status: json['status'] ?? '',
        cancelReason: json['cancelReason'] ?? '',
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
    } catch (e, stack) {
      print("❌ Lỗi khi parse Order: $e");
      print("🔍 Stack trace: $stack");
      rethrow;
    }
  }
}
