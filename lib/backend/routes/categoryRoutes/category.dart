import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controller/categoryController/categoryController.dart';

class CategoryRoutes {
  Router get router {
    final router = Router();

    router.get('/', getCategories);

    router.get('/featured', getFeaturedCategories);

    router.post('/add', addCategory);
    router.get('/<ignored|.*>', (Request request) async {
      return Response(
        404,
        body: jsonEncode({
          "success": false,
          "message": "Category Route Not Found"
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    });

    return router;
  }
}