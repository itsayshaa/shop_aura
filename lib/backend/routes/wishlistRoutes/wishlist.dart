import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shop_aura/backend/controller/wishlistController/wishlistController.dart';

class WishlistRoutes {
  Router get router {
    final router = Router();

    router.get('/', getWishlist);
    router.post('/toggle', toggleWishlist);
    router.post('/remove', removeFromWishlist);
    router.post('/clear', clearWishlist);

    router.get('/<ignored|.*>', (Request request) async {
      return Response(
        404,
        body: jsonEncode({
          "success": false,
          "message": "Wishlist Route Not Found"
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    });

    return router;
  }
}
