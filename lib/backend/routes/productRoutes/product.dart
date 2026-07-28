import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controller/productController/productController.dart';

class ProductRoutes {
  Router get router {
    final router = Router();

    // GET ALL PRODUCTS
    router.get('/', getProducts);

    // GET PRODUCT DETAILS
    router.get('/<id>', getProduct);

    // GET PRODUCTS BY CATEGORY
    router.get('/category/<categoryId>', getProductsByCategory);

    // ADD PRODUCT
    router.post('/add', addProduct);

    // 404
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