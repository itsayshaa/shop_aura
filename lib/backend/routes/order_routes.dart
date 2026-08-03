import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controller/order_controller.dart';
import '../controller/refund_controller.dart';

class OrderRoutes {
  Router get router {
    final router = Router();

    router.get('/', OrderController.getOrders);
    router.post('/create', OrderController.createOrder);
    router.post('/payment/process', OrderController.processPayment);
    router.get('/admin/all', OrderController.getAdminOrders);
    router.post('/admin/update-status', OrderController.updateOrderStatus);

    // Fallbacks for refund actions on order routes for backward compatibility
    router.post('/refund/request', RefundController.requestRefund);
    router.post('/admin/refund/process', RefundController.processAdminRefund);

    router.get('/<ignored|.*>', (Request request) async {
      return Response(
        404,
        body: jsonEncode({
          "success": false,
          "message": "Order Route Not Found"
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    });

    return router;
  }
}
