class OrderItem {
  final String name;
  final String image;
  final int quantity;
  final double price;

  OrderItem({
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

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'],
      image: json['image'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

class OrderModel {
  final String id;
  final DateTime date;
  final String status;
  final String paymentMethod;
  final String name;
  final String phone;
  final String address;
  final List<OrderItem> items;
  final double totalAmount;

  OrderModel({
  required this.id,
  required this.items,
  required this.totalAmount,
  required this.date,
  required this.status,
  required this.name,
  required this.phone,
  required this.address,
  required this.paymentMethod,
});

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'status': status,
        'paymentMethod': paymentMethod,
        'name': name,
        'phone': phone,
        'address': address,
        'items': items.map((e) => e.toJson()).toList(),
        'totalAmount': totalAmount,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      items: (json['items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}