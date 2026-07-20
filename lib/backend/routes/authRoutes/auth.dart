import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shop_aura/backend/controller/authController/authController.dart';

class AuthRoutes{
  Router get router{
    final router = Router();
    router.post('/register',registerUser);
    router.post('/login',loginUser);
    router.get('/users',getUser);
    router.get('/',(request)async{
      return Response(
        404,
        body: jsonEncode({
          "success":false,
          "message":"route not found"
    })
      );
    });
    return router;
  }
}