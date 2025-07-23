class ShippingAddress {
  final String? phone;
  final String? address;
  final String? city;

  ShippingAddress({this.phone, this.address, this.city});

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'address': address,
      'city': city,
    };
  }
}

class WishlistItem {
  final String? productId;
  final String? productName;
  final String? productImg;

  WishlistItem({this.productId, this.productName, this.productImg});

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      productId: json['productId'],
      productName: json['ProductName'],
      productImg: json['ProductImg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'ProductName': productName,
      'ProductImg': productImg,
    };
  }
}

class UserModel {
  final String? id;
  final String? userName;
  final String email;
  final String? image;
  final String? accountStatus;
  final bool? isAdmin;
  final String? accessToken;
  final String? refreshToken;
  final bool? emailVerified;
  final int? following;
  final List<ShippingAddress>? shippingAddress;
  final List<WishlistItem>? wishlist;

  UserModel({
    this.id,
    this.userName,
    required this.email,
    this.image,
    this.accountStatus,
    this.isAdmin,
    this.accessToken,
    this.refreshToken,
    this.emailVerified,
    this.following,
    this.shippingAddress,
    this.wishlist,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        id: json['_id'],
        userName: json['userName'],
        email: json['email'] ?? "", // fallback an empty string
        image: json['image'],
        accountStatus: json['accountStatus'],
        isAdmin: json['isAdmin'],
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        emailVerified: json['emailVerified'],
        following: json['following'],
        shippingAddress: (json['shippingAddress'] as List?)
            ?.map((e) => ShippingAddress.fromJson(e))
            .toList(),
        wishlist: (json['wishlist'] as List?)
            ?.map((e) => WishlistItem.fromJson(e))
            .toList(),
      );
    } catch (e) {
      print("Lỗi khi parse UserModel: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userName': userName,
      'email': email,
      'image': image,
      'accountStatus': accountStatus,
      'isAdmin': isAdmin,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'emailVerified': emailVerified,
      'following': following,
      'shippingAddress': shippingAddress?.map((e) => e.toJson()).toList(),
      'wishlist': wishlist?.map((e) => e.toJson()).toList(),
    };
  }
}