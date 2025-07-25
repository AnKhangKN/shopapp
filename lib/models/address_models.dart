class ShippingAddress {
  final String phone;
  final String address;
  final String city;

  ShippingAddress({
    required this.phone,
    required this.address,
    required this.city,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
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
