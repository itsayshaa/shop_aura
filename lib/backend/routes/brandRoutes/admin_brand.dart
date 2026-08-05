import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controller/brandController/admin_brand_controller.dart';

class AdminBrandRoutes {
  Router get router {
    final router = Router();

    // Get all brands
    router.get('/', adminGetAllBrands);

    // Search brands
    // Keep this before '/<id>'
    router.get('/search/<keyword>', adminSearchBrands);

    // Get one brand
    router.get('/<id>', adminGetBrand);

    // Add a new brand
    router.post('/add', adminAddBrand);

    // Update a brand
    router.put('/<id>', adminUpdateBrand);

    // Delete a brand
    router.delete('/<id>', adminDeleteBrand);

    // Change brand active/inactive status
    router.patch('/<id>/status', adminUpdateBrandStatus);

    // Admin brand route not found
    router.get('/<ignored|.*>', (Request request) {
      return Response(
        404,
        body: jsonEncode({
          'success': false,
          'message': 'Admin Brand Route Not Found',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return router;
  }
}
