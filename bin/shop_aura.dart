import 'dart:io';
import 'package:shop_aura/backend/database/mongo_service.dart';
import 'package:shop_aura/backend/routes/authRoutes/auth.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Future<void> main()async{
  await MongoService.connect();
  final router = Router();
  router.mount('/', AuthRoutes().router.call);
  // router.mount('/', LoginPage())
  final handler = Pipeline()
    .addMiddleware(logRequests())
    .addMiddleware(corsHeader())
    .addHandler(router.call);
  
  final server = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4,
    5000
  );
  print("Server running on http://localhost:5000");
}

Middleware corsHeader(){
  return createMiddleware(
    requestHandler: (Request request){
      if(request.method == "OPTIONS"){
        return Response.ok(
          '',
         headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers':
                'Origin, Content-Type, Accept',
            'Access-Control-Allow-Methods':
                'GET, POST, PUT, DELETE, OPTIONS',
          },
        );
      }
      return null;
    },
    responseHandler: (Response response){
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
    }
  );
}