class ProductDetail {
  final String? size;
  final String color;
  final int price;
  final int quantity;

  ProductDetail({
    this.size,
    required this.color,
    required this.price,
    required this.quantity,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      size: json['size'],
      color: json['color'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}
