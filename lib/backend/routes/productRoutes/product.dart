import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controller/productController/productController.dart';

class ProductRoutes {
  Router get router {
    final router = Router();

    router.get('/', getProducts);

    router.get('/<id>', getProduct);

    router.get('/category/<categoryId>', getProductsByCategory);

    router.post('/add', addProduct);

    router.get('/<ignored|.*>', (Request request) async {
      return Response(
        404,
        body: jsonEncode({
          "success": false,
          "message": "Product Route Not Found"
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    });

    return router;
  }
}