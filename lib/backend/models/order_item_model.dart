class OrderItemModel {
  final String name;
  final String image;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'quantity': quantity,
        'price': price,
      };

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      quantity: (json['quantity'] as num? ?? 1).toInt(),
      price: (json['price'] as num? ?? 0.0).toDouble(),
    );
  }
}
