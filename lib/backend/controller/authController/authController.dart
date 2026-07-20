import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shop_aura/backend/database/mongo_service.dart';

Future<Response> registerUser(Request request)async{
  final body = await request.readAsString();
  final data = jsonDecode(body);

  final existing = await MongoService.users.findOne(
    where.eq("email",data["email"])
  );
  if(existing != null){
    return Response(
      400,
      body: jsonEncode({
        "success":false,
        "message":"Email already exist"
      }),
      headers: {"Content-Type":"application/json"}
    );
  }
  await MongoService.users.insertOne({
    "name":data["name"],
    "email":data["email"],
    "phone":data["phone"],
    "password":data["password"]
  });
  return Response.ok(
    jsonEncode({
      "success":false,
      "message":"Register Success"
    }),
    headers: {"Content-Type":"application/json"}
  );
}

Future<Response> loginUser(Request request)async{
  final body = await request.readAsString();
  final data = jsonDecode(body);

  final user = await MongoService.users.findOne(
    where.eq("email",data["email"])
);
  if(user == null){
    return Response(
      400,
      body: jsonEncode({
        "success":false,
        "message":"Please Register First"
      }),
      headers: {
        "Content-Type":"application/json"
      }
    );
  }
  if(user["password"] != data["password"]){
    return Response(
      401,
      body: jsonEncode({
        "success":false,
        "message":"Password Not match"
      }),
      headers: {"Content-Type":"application/json"}
    );
  }
return Response.ok(
  jsonEncode({
    "success":true,
    "message":"login success"
  }),
  headers: {"Content-Type":"application/json"}
);
}

Future<Response> getUser(Request request)async{
  final users = await MongoService.users.find().toList();
  return Response.ok(
    jsonEncode(users),
    headers: {"Content-Type":"application/json"}
  );
}