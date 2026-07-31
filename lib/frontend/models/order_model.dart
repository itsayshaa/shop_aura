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
  final String? refundStatus;
  final String? refundReason;
  final DateTime? refundRequestedAt;
  final String? paymentStatus;
  final String? transactionId;

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
    this.refundStatus,
    this.refundReason,
    this.refundRequestedAt,
    this.paymentStatus,
    this.transactionId,
  });

  OrderModel copyWith({
    String? id,
    DateTime? date,
    String? status,
    String? paymentMethod,
    String? name,
    String? phone,
    String? address,
    List<OrderItem>? items,
    double? totalAmount,
    String? refundStatus,
    String? refundReason,
    DateTime? refundRequestedAt,
    String? paymentStatus,
    String? transactionId,
  }) {
    return OrderModel(
      id: id ?? this.id,
      date: date ?? this.date,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      refundStatus: refundStatus ?? this.refundStatus,
      refundReason: refundReason ?? this.refundReason,
      refundRequestedAt: refundRequestedAt ?? this.refundRequestedAt,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      transactionId: transactionId ?? this.transactionId,
    );
  }

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
        'refundStatus': refundStatus,
        'refundReason': refundReason,
        'refundRequestedAt': refundRequestedAt?.toIso8601String(),
        'paymentStatus': paymentStatus,
        'transactionId': transactionId,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      status: json['status'] ?? 'Processing',
      paymentMethod: json['paymentMethod'] ?? 'COD',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((e) => OrderItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      totalAmount: (json['totalAmount'] as num? ?? 0.0).toDouble(),
      refundStatus: json['refundStatus'],
      refundReason: json['refundReason'],
      refundRequestedAt: json['refundRequestedAt'] != null
          ? DateTime.tryParse(json['refundRequestedAt'])
          : null,
      paymentStatus: json['paymentStatus'],
      transactionId: json['transactionId'],
    );
  }
}