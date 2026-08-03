import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controller/refund_controller.dart';

class RefundRoutes {
  Router get router {
    final router = Router();

    router.post('/request', RefundController.requestRefund);
    router.post('/admin/process', RefundController.processAdminRefund);
    router.get('/admin/all', RefundController.getAdminRefunds);

    router.get('/<ignored|.*>', (Request request) async {
      return Response(
        404,
        body: jsonEncode({
          "success": false,
          "message": "Refund Route Not Found"
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    });

    return router;
  }
}
