class Sale {
  final int? price;
  final DateTime? startDate;
  final DateTime? endDate;

  Sale({
    this.price,
    this.startDate,
    this.endDate,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      price: json['price'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
    );
  }
}
