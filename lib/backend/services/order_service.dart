import 'package:mongo_dart/mongo_dart.dart';
import '../database/mongo_service.dart';

class BackendOrderService {
  static Future<List<Map<String, dynamic>>> fetchUserOrders(String userId) async {
    final orders = await MongoService.orders
        .find(where.eq("userId", userId).sortBy("date", descending: true))
        .toList();
    return orders;
  }

  static Future<List<Map<String, dynamic>>> fetchAllOrdersAdmin() async {
    final orders = await MongoService.orders
        .find(where.sortBy("date", descending: true))
        .toList();
    return orders;
  }

  static Future<Map<String, dynamic>> createOrder({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    final String orderId = data["id"] ?? "ORD_${DateTime.now().millisecondsSinceEpoch}";
    final List items = data["items"] ?? [];
    final double totalAmount = (data["totalAmount"] ?? 0.0).toDouble();
    final String status = data["status"] ?? "Processing";
    final String name = data["name"] ?? "";
    final String phone = data["phone"] ?? "";
    final String address = data["address"] ?? "";
    final String paymentMethod = data["paymentMethod"] ?? "COD";
    final String paymentStatus = data["paymentStatus"] ?? (paymentMethod.toLowerCase() == "cod" ? "Pending" : "Paid");
    final String transactionId = data["transactionId"] ?? "TXN_${DateTime.now().millisecondsSinceEpoch}";

    final newOrder = {
      "id": orderId,
      "userId": userId,
      "items": items,
      "totalAmount": totalAmount,
      "date": DateTime.now().toUtc().toIso8601String(),
      "status": status,
      "name": name,
      "phone": phone,
      "address": address,
      "paymentMethod": paymentMethod,
      "paymentStatus": paymentStatus,
      "transactionId": transactionId,
      "refundStatus": null,
      "refundReason": null,
      "refundRequestedAt": null,
    };

    await MongoService.orders.insertOne(newOrder);

    // Clear cart for user
    await MongoService.cart.updateOne(
      where.eq("userId", userId),
      modify.set("items", []),
    );

    return newOrder;
  }

  static Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    final result = await MongoService.orders.updateOne(
      where.eq("id", orderId),
      modify.set("status", newStatus),
    );
    return result.isSuccess;
  }
}
