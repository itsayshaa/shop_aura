import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shop_aura/backend/database/mongo_service.dart';
import 'package:shop_aura/backend/services/jwtService.dart';

Future<Response> getOrders(Request request) async {
  try {
    final userId = Jwtservice.getUserIdFromRequest(request);
    if (userId == null) {
      return Response(401, body: jsonEncode({"success": false, "message": "Unauthorized"}), headers: {"Content-Type": "application/json"});
    }

    // Find all orders for this user
    final orders = await MongoService.orders.find(where.eq("userId", userId).sortBy("date", descending: true)).toList();
    final cleanOrders = orders.map((o) {
      final map = Map<String, dynamic>.from(o);
      if (map['_id'] != null) {
        map['_id'] = map['_id'].toString();
      }
      return map;
    }).toList();

    return Response.ok(jsonEncode(cleanOrders), headers: {"Content-Type": "application/json"});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}

Future<Response> createOrder(Request request) async {
  try {
    final userId = Jwtservice.getUserIdFromRequest(request);
    if (userId == null) {
      return Response(401, body: jsonEncode({"success": false, "message": "Unauthorized"}), headers: {"Content-Type": "application/json"});
    }

    final body = await request.readAsString();
    final data = jsonDecode(body);

    final String orderId = data["id"] ?? "ORD_${DateTime.now().millisecondsSinceEpoch}";
    final List items = data["items"] ?? [];
    final double totalAmount = (data["totalAmount"] ?? 0.0).toDouble();
    final String status = data["status"] ?? "Processing";
    final String name = data["name"] ?? "";
    final String phone = data["phone"] ?? "";
    final String address = data["address"] ?? "";
    final String paymentMethod = data["paymentMethod"] ?? "";
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

    // Insert order in database
    await MongoService.orders.insertOne(newOrder);
    if (newOrder['_id'] != null) {
      newOrder['_id'] = newOrder['_id'].toString();
    }

    // Clear the cart for this user in the database
    await MongoService.cart.updateOne(
      where.eq("userId", userId),
      modify.set("items", []),
    );

    return Response.ok(
      jsonEncode({
        "success": true,
        "message": "Order created successfully",
        "order": newOrder
      }),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}

Future<Response> processPayment(Request request) async {
  try {
    final userId = Jwtservice.getUserIdFromRequest(request);
    if (userId == null) {
      return Response(401, body: jsonEncode({"success": false, "message": "Unauthorized"}), headers: {"Content-Type": "application/json"});
    }

    final body = await request.readAsString();
    final data = jsonDecode(body);
    final String paymentMethod = data["paymentMethod"] ?? "card";
    final double amount = (data["amount"] ?? 0.0).toDouble();

    if (amount <= 0) {
      return Response(400, body: jsonEncode({"success": false, "message": "Invalid transaction amount"}), headers: {"Content-Type": "application/json"});
    }

    final String transactionId = "TXN_${DateTime.now().millisecondsSinceEpoch}_${userId.length >= 4 ? userId.substring(userId.length - 4) : 'USER'}";

    return Response.ok(
      jsonEncode({
        "success": true,
        "message": "Payment of ₹${amount.toStringAsFixed(2)} processed successfully via ${paymentMethod.toUpperCase()}.",
        "transactionId": transactionId,
        "paymentStatus": paymentMethod.toLowerCase() == 'cod' ? 'Pending' : 'Paid',
      }),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}

Future<Response> requestRefund(Request request) async {
  try {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final String orderId = data["orderId"] ?? "";
    final String reason = data["reason"] ?? "Customer request";

    if (orderId.isEmpty) {
      return Response(400, body: jsonEncode({"success": false, "message": "Missing orderId"}), headers: {"Content-Type": "application/json"});
    }

    final updateResult = await MongoService.orders.updateOne(
      where.eq("id", orderId),
      modify
          .set("refundStatus", "Requested")
          .set("refundReason", reason)
          .set("refundRequestedAt", DateTime.now().toUtc().toIso8601String()),
    );

    return Response.ok(
      jsonEncode({
        "success": true,
        "message": "Refund requested successfully",
        "orderId": orderId,
        "refundStatus": "Requested",
        "reason": reason,
      }),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}

Future<Response> getAdminOrders(Request request) async {
  try {
    final orders = await MongoService.orders.find(where.sortBy("date", descending: true)).toList();
    final cleanOrders = orders.map((o) {
      final map = Map<String, dynamic>.from(o);
      if (map['_id'] != null) {
        map['_id'] = map['_id'].toString();
      }
      return map;
    }).toList();
    return Response.ok(jsonEncode(cleanOrders), headers: {"Content-Type": "application/json"});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}

Future<Response> updateOrderStatus(Request request) async {
  try {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final String orderId = data["orderId"] ?? "";
    final String newStatus = data["status"] ?? "Processing";

    if (orderId.isEmpty) {
      return Response(400, body: jsonEncode({"success": false, "message": "Missing orderId"}), headers: {"Content-Type": "application/json"});
    }

    await MongoService.orders.updateOne(
      where.eq("id", orderId),
      modify.set("status", newStatus),
    );

    return Response.ok(
      jsonEncode({
        "success": true,
        "message": "Order status updated to $newStatus",
        "orderId": orderId,
        "status": newStatus,
      }),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}

Future<Response> processAdminRefund(Request request) async {
  try {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final String orderId = data["orderId"] ?? "";
    final String action = data["action"] ?? "approve"; // approve, reject, refund

    if (orderId.isEmpty) {
      return Response(400, body: jsonEncode({"success": false, "message": "Missing orderId"}), headers: {"Content-Type": "application/json"});
    }

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

    return Response.ok(
      jsonEncode({
        "success": true,
        "message": "Refund action '$action' processed successfully",
        "orderId": orderId,
        "refundStatus": refundStatus,
        "paymentStatus": paymentStatus,
        "refundTransactionId": refundTxnId,
      }),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}
