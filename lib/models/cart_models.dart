class CartItem {
  final String productId;
  final String? productName;
  final String? productImage;
  final String? size;
  final String color;
  final int price; // Đổi từ double -> int
  final int quantity;

  CartItem({
    required this.productId,
    this.productName,
    this.productImage,
    this.size,
    required this.color,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      productName: json['productName'],
      productImage: json['productImage'],
      size: json['size'],
      color: json['color'],
      price: json['price'], // Giữ nguyên kiểu int
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'size': size,
      'color': color,
      'price': price,
      'quantity': quantity,
    };
  }
}
