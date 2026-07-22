import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shop_aura/backend/controller/authController/authController.dart';
import 'package:shop_aura/backend/controller/authController/emailController.dart';
import 'package:shop_aura/backend/controller/authController/passwordController.dart';

class AuthRoutes{
  Router get router{
    final router = Router();
    router.post('/register',registerUser);
    router.post('/login',loginUser);
    router.post('/forgotpassword',sendOtp);
    router.post('/verify-otp',verifyOtp);
    router.post('/changepassword',changePassword);
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