import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/api_service.dart';
import '../services/jwtService.dart';
import '../services/order_service.dart';

class OrderController {
  static Future<Response> getOrders(Request request) async {
    try {
      final userId = Jwtservice.getUserIdFromRequest(request);
      if (userId == null) {
        return ApiService.unauthorized();
      }

      final orders = await BackendOrderService.fetchUserOrders(userId);
      return ApiService.success(data: orders);
    } catch (e) {
      return ApiService.internalError(e);
    }
  }

  static Future<Response> createOrder(Request request) async {
    try {
      final userId = Jwtservice.getUserIdFromRequest(request);
      if (userId == null) {
        return ApiService.unauthorized();
      }

      final body = await request.readAsString();
      final data = jsonDecode(body);

      final newOrder = await BackendOrderService.createOrder(
        userId: userId,
        data: Map<String, dynamic>.from(data),
      );

      return ApiService.success(
        data: {"order": newOrder},
        message: "Order created successfully",
      );
    } catch (e) {
      return ApiService.internalError(e);
    }
  }

  static Future<Response> getAdminOrders(Request request) async {
    try {
      final orders = await BackendOrderService.fetchAllOrdersAdmin();
      return ApiService.success(data: orders);
    } catch (e) {
      return ApiService.internalError(e);
    }
  }

  static Future<Response> updateOrderStatus(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final String orderId = data["orderId"] ?? "";
      final String newStatus = data["status"] ?? "Processing";

      if (orderId.isEmpty) {
        return ApiService.error(message: "Missing orderId");
      }

      await BackendOrderService.updateOrderStatus(orderId, newStatus);

      return ApiService.success(
        data: {
          "orderId": orderId,
          "status": newStatus,
        },
        message: "Order status updated to $newStatus",
      );
    } catch (e) {
      return ApiService.internalError(e);
    }
  }

  static Future<Response> processPayment(Request request) async {
    try {
      final userId = Jwtservice.getUserIdFromRequest(request);
      if (userId == null) {
        return ApiService.unauthorized();
      }

      final body = await request.readAsString();
      final data = jsonDecode(body);
      final String paymentMethod = data["paymentMethod"] ?? "card";
      final double amount = (data["amount"] ?? 0.0).toDouble();

      if (amount <= 0) {
        return ApiService.error(message: "Invalid transaction amount");
      }

      final String transactionId =
          "TXN_${DateTime.now().millisecondsSinceEpoch}_${userId.length >= 4 ? userId.substring(userId.length - 4) : 'USER'}";

      return ApiService.success(
        data: {
          "transactionId": transactionId,
          "paymentStatus": paymentMethod.toLowerCase() == 'cod' ? 'Pending' : 'Paid',
        },
        message: "Payment of ₹${amount.toStringAsFixed(2)} processed successfully via ${paymentMethod.toUpperCase()}.",
      );
    } catch (e) {
      return ApiService.internalError(e);
    }
  }
}
