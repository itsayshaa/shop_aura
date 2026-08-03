import 'dart:io';
import 'package:shop_aura/backend/routes/authRoutes/auth.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shop_aura/backend/routes/categoryRoutes/category.dart';
import 'package:shop_aura/backend/routes/productRoutes/product.dart';
import 'package:shop_aura/backend/routes/cartRoutes/cart.dart';
import 'package:shop_aura/backend/routes/wishlistRoutes/wishlist.dart';
import 'package:shop_aura/backend/routes/order_routes.dart';
import 'package:shop_aura/backend/routes/refund_routes.dart';
import 'package:shop_aura/backend/database/mongo_service.dart';
Future<void> main() async {
  await MongoService.connect();
  final router = Router();
  router.mount('/auth/', AuthRoutes().router.call);
  router.mount('/category/', CategoryRoutes().router.call);
  router.mount('/product/', ProductRoutes().router.call);
  router.mount('/cart/', CartRoutes().router.call);
  router.mount('/wishlist/', WishlistRoutes().router.call);
  router.mount('/order/', OrderRoutes().router.call);
  router.mount('/refund/', RefundRoutes().router.call);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeader())
      .addHandler(router.call);

  final server = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4,
    5000,
  );
  print("Server running on http://${server.address.host}:${server.port}");
}

Middleware corsHeader() {
  return createMiddleware(
    requestHandler: (Request request) {
      if (request.method == "OPTIONS") {
        return Response.ok(
          '',
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers':
                'Origin, Content-Type, Accept, Authorization',
            'Access-Control-Allow-Methods':
                'GET, POST, PUT, DELETE, OPTIONS',
          },
        );
      }
      return null;
    },
    responseHandler: (Response response) {
      return response.change(
        headers: {
          ...response.headers,
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers':
              'Origin, Content-Type, Accept',
          'Access-Control-Allow-Methods':
              'GET, POST, PUT, DELETE, OPTIONS',
        },
      );
    },
  );
}