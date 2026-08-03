import 'order_item_model.dart';

class OrderModelBackend {
  final String id;
  final String userId;
  final List<OrderItemModel> items;
  final double totalAmount;
  final DateTime date;
  final String status;
  final String name;
  final String phone;
  final String address;
  final String paymentMethod;
  final String paymentStatus;
  final String transactionId;
  final String? refundStatus;
  final String? refundReason;
  final DateTime? refundRequestedAt;
  final String? refundTransactionId;

  OrderModelBackend({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.date,
    required this.status,
    required this.name,
    required this.phone,
    required this.address,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.transactionId,
    this.refundStatus,
    this.refundReason,
    this.refundRequestedAt,
    this.refundTransactionId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'items': items.map((e) => e.toJson()).toList(),
        'totalAmount': totalAmount,
        'date': date.toIso8601String(),
        'status': status,
        'name': name,
        'phone': phone,
        'address': address,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'transactionId': transactionId,
        'refundStatus': refundStatus,
        'refundReason': refundReason,
        'refundRequestedAt': refundRequestedAt?.toIso8601String(),
        'refundTransactionId': refundTransactionId,
      };

  factory OrderModelBackend.fromJson(Map<String, dynamic> json) {
    return OrderModelBackend(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((e) => OrderItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      totalAmount: (json['totalAmount'] as num? ?? 0.0).toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      status: json['status'] ?? 'Processing',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 'COD',
      paymentStatus: json['paymentStatus'] ?? 'Pending',
      transactionId: json['transactionId'] ?? '',
      refundStatus: json['refundStatus'],
      refundReason: json['refundReason'],
      refundRequestedAt: json['refundRequestedAt'] != null
          ? DateTime.tryParse(json['refundRequestedAt'])
          : null,
      refundTransactionId: json['refundTransactionId'],
    );
  }
}
