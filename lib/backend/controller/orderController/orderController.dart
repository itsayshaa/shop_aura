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

    return Response.ok(jsonEncode(orders), headers: {"Content-Type": "application/json"});
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
      "paymentMethod": paymentMethod
    };

    // Insert order in database
    await MongoService.orders.insertOne(newOrder);

    // Clear the cart for this user in the database
    await MongoService.carts.updateOne(
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

    // Perform validation or dummy checks
    if (amount <= 0) {
      return Response(400, body: jsonEncode({"success": false, "message": "Invalid transaction amount"}), headers: {"Content-Type": "application/json"});
    }

    final String transactionId = "TXN_${DateTime.now().millisecondsSinceEpoch}_${userId.substring(userId.length - 4)}";

    return Response.ok(
      jsonEncode({
        "success": true,
        "message": "Payment of ₹${amount.toStringAsFixed(2)} processed successfully via ${paymentMethod.toUpperCase()}.",
        "transactionId": transactionId,
      }),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}
