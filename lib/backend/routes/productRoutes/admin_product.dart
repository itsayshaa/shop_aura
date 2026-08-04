import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controller/productController/admin_product_controller.dart';

class AdminProductRoutes {
  Router get router {
    final router = Router();

    // Get all products
    router.get(
      '/',
      adminGetProducts,
    );

    // Search products
    router.get(
      '/search/<keyword>',
      adminSearchProducts,
    );

    // Add a new product
    router.post(
      '/add',
      adminAddProduct,
    );

    // Update product status
    router.patch(
      '/<id>/status',
      adminUpdateProductStatus,
    );

    // Update a product
    router.put(
      '/<id>',
      adminUpdateProduct,
    );

    // Delete a product
    router.delete(
      '/<id>',
      adminDeleteProduct,
    );

    // Get one product
    router.get(
      '/<id>',
      adminGetProduct,
    );

    // Admin product route not found
    router.all(
      '/<ignored|.*>',
      (Request request) {
        return Response(
          404,
          body: jsonEncode({
            'success': false,
            'message':
                'Admin Product Route Not Found',
          }),
          headers: {
            'Content-Type':
                'application/json',
          },
        );
      },
    );

    return router;
  }
}