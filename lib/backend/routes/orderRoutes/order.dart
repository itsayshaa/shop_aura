import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shop_aura/backend/controller/orderController/orderController.dart';

class OrderRoutes {
  Router get router {
    final router = Router();

    router.get('/', getOrders);
    router.post('/create', createOrder);
    router.post('/payment/process', processPayment);
    router.post('/refund/request', requestRefund);
    router.get('/admin/all', getAdminOrders);
    router.post('/admin/update-status', updateOrderStatus);
    router.post('/admin/refund/process', processAdminRefund);

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
