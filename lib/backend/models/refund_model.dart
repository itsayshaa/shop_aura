class RefundModel {
  final String orderId;
  final String? refundStatus;
  final String? refundReason;
  final DateTime? refundRequestedAt;
  final String? refundTransactionId;
  final String? action;

  RefundModel({
    required this.orderId,
    this.refundStatus,
    this.refundReason,
    this.refundRequestedAt,
    this.refundTransactionId,
    this.action,
  });

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'refundStatus': refundStatus,
        'refundReason': refundReason,
        'refundRequestedAt': refundRequestedAt?.toIso8601String(),
        'refundTransactionId': refundTransactionId,
        'action': action,
      };

  factory RefundModel.fromJson(Map<String, dynamic> json) {
    return RefundModel(
      orderId: json['orderId'] ?? '',
      refundStatus: json['refundStatus'],
      refundReason: json['refundReason'],
      refundRequestedAt: json['refundRequestedAt'] != null
          ? DateTime.tryParse(json['refundRequestedAt'])
          : null,
      refundTransactionId: json['refundTransactionId'],
      action: json['action'],
    );
  }
}
