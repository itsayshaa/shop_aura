import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/api_service.dart';
import '../services/refund_service.dart';

class RefundController {
  static Future<Response> requestRefund(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final String orderId = data["orderId"] ?? "";
      final String reason = data["reason"] ?? "Customer request";

      if (orderId.isEmpty) {
        return ApiService.error(message: "Missing orderId");
      }

      final result = await BackendRefundService.requestRefund(
        orderId: orderId,
        reason: reason,
      );

      return ApiService.success(
        data: result,
        message: "Refund requested successfully",
      );
    } catch (e) {
      return ApiService.internalError(e);
    }
  }

  static Future<Response> processAdminRefund(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final String orderId = data["orderId"] ?? "";
      final String action = data["action"] ?? "approve";

      if (orderId.isEmpty) {
        return ApiService.error(message: "Missing orderId");
      }

      final result = await BackendRefundService.processAdminRefund(
        orderId: orderId,
        action: action,
      );

      return ApiService.success(
        data: result,
        message: "Refund action '$action' processed successfully",
      );
    } catch (e) {
      return ApiService.internalError(e);
    }
  }

  static Future<Response> getAdminRefunds(Request request) async {
    try {
      final refunds = await BackendRefundService.fetchAllRefunds();
      return ApiService.success(data: refunds);
    } catch (e) {
      return ApiService.internalError(e);
    }
  }
}
