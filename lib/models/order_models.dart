import 'package:shopapp/models/order_item_models.dart';
import 'package:shopapp/models/address_models.dart';

class Order {
  final ShippingAddress shippingAddress;
  final List<OrderItem> items;
  final String orderNote;
  final double totalPrice;
  final double shippingPrice;
  final String paymentMethod; // cod or creditCard

  Order({
    required this.shippingAddress,
    required this.items,
    required this.orderNote,
    required this.totalPrice,
    required this.shippingPrice,
    required this.paymentMethod,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      shippingAddress: ShippingAddress.fromJson(json['shippingAddress']),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      orderNote: json['orderNote'] ?? '',
      totalPrice: (json['totalPrice'] as num).toDouble(),
      shippingPrice: (json['shippingPrice'] as num).toDouble(),
      paymentMethod: json['paymentMethod'],
    );
  }
}
