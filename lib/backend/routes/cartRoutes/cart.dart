import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shop_aura/backend/controller/cartController/cartController.dart';

class CartRoutes {
  Router get router {
    final router = Router();

    router.get('/', getCart);
    router.post('/add', addToCart);
    router.post('/update', updateQuantity);
    router.post('/remove', removeFromCart);
    router.post('/clear', clearCart);

    router.get('/<ignored|.*>', (Request request) async {
      return Response(
        404,
        body: jsonEncode({
          "success": false,
          "message": "Cart Route Not Found"
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    });

    return router;
  }
}
