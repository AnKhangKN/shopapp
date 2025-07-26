class WishList {
  final String productId;
  final String productName;
  final String productImg;

  WishList({
    required this.productId,
    required this.productName,
    required this.productImg,
  });

  factory WishList.fromJson(Map<String, dynamic> json) {
    return WishList(
      productId: json['productId'],
      productName: json['productName'],
      productImg: json['productImg'],
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'productId': productId,
      'productName': productName,
      'productImg': productImg,
    };
  }
}
