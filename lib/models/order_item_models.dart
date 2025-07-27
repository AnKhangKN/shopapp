class OrderItem {
  final String productId;
  final String productImage;
  final String productName;
  final String? size;
  final String color;
  final double price;
  final int quantity;
  final DateTime? createAt;

  OrderItem({
    required this.productId,
    required this.productImage,
    required this.productName,
    this.size,
    required this.color,
    required this.price,
    required this.quantity,
    required this.createAt
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productImage: json['productImage'],
      productName: json['productName'],
      size: json['size'],
      color: json['color'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      createAt: json['createAt']
    );
  }
}
