import 'package:mongo_dart/mongo_dart.dart';
import '../database/mongo_service.dart';
import 'notification_service.dart';

class BackendRefundService {
  static Future<Map<String, dynamic>> requestRefund({
    required String orderId,
    required String reason,
  }) async {
    final nowIso = DateTime.now().toUtc().toIso8601String();
    await MongoService.orders.updateOne(
      where.eq("id", orderId),
      modify
          .set("refundStatus", "Requested")
          .set("refundReason", reason)
          .set("refundRequestedAt", nowIso),
    );

    final refundRecord = {
      "orderId": orderId,
      "refundStatus": "Requested",
      "refundReason": reason,
      "refundRequestedAt": nowIso,
    };

    await MongoService.refunds.insertOne(Map<String, dynamic>.from(refundRecord));

    return refundRecord;
  }

  static Future<Map<String, dynamic>> processAdminRefund({
    required String orderId,
    required String action,
  }) async {
    String refundStatus;
    String paymentStatus;

    if (action.toLowerCase() == "approve") {
      refundStatus = "Approved";
      paymentStatus = "Refund Pending";
    } else if (action.toLowerCase() == "reject") {
      refundStatus = "Rejected";
      paymentStatus = "Paid";
    } else {
      refundStatus = "Refunded";
      paymentStatus = "Refunded";
    }

    final refundTxnId = "RFND_${DateTime.now().millisecondsSinceEpoch}";

    await MongoService.orders.updateOne(
      where.eq("id", orderId),
      modify
          .set("refundStatus", refundStatus)
          .set("paymentStatus", paymentStatus)
          .set("refundTransactionId", refundTxnId),
    );

    await NotificationService.sendRefundStatusNotification(
      orderId: orderId,
      refundStatus: refundStatus,
    );

    return {
      "orderId": orderId,
      "refundStatus": refundStatus,
      "paymentStatus": paymentStatus,
      "refundTransactionId": refundTxnId,
      "action": action,
    };
  }

  static Future<List<Map<String, dynamic>>> fetchAllRefunds() async {
    final ordersWithRefunds = await MongoService.orders
        .find(where.ne("refundStatus", null).sortBy("date", descending: true))
        .toList();
    return ordersWithRefunds;
  }
}
