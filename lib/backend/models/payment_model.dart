class PaymentModel {
  final String paymentMethod;
  final String paymentStatus;
  final String transactionId;
  final double amount;

  PaymentModel({
    required this.paymentMethod,
    required this.paymentStatus,
    required this.transactionId,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'transactionId': transactionId,
        'amount': amount,
      };

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentMethod: json['paymentMethod'] ?? 'COD',
      paymentStatus: json['paymentStatus'] ?? 'Pending',
      transactionId: json['transactionId'] ?? '',
      amount: (json['amount'] as num? ?? 0.0).toDouble(),
    );
  }
}
