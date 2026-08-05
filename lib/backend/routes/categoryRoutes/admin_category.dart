import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controller/categoryController/admin_category_controller.dart';

class AdminCategoryRoutes {
  Router get router {
    final router = Router();

    // Get all categories
    router.get(
      '/',
      adminGetAllCategories,
    );

    // Search categories
    // Keep this before '/<id>'
    router.get(
      '/search/<keyword>',
      adminSearchCategories,
    );

    // Get one category
    router.get(
      '/<id>',
      adminGetCategory,
    );

    // Add a new category
    router.post(
      '/add',
      adminAddCategory,
    );

    // Update a category
    router.put(
      '/<id>',
      adminUpdateCategory,
    );

    // Delete a category
    router.delete(
      '/<id>',
      adminDeleteCategory,
    );

    // Change category active/inactive status
    router.patch(
      '/<id>/status',
      adminUpdateCategoryStatus,
    );

    // Admin category route not found
    router.get(
      '/<ignored|.*>',
      (Request request) {
        return Response(
          404,
          body: jsonEncode({
            'success': false,
            'message': 'Admin Category Route Not Found',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );
      },
    );

    return router;
  }
}