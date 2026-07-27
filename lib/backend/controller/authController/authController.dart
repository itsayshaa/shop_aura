import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shop_aura/backend/database/mongo_service.dart';
import 'package:crypto/crypto.dart';
import 'package:shop_aura/backend/models/client/userModel.dart';
import 'package:shop_aura/backend/services/jwtService.dart';
 String hashPassword(String password){
  return sha256.
  convert(utf8.encode(password)).toString();
}
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
  final user = UserModel(
    name: data["name"],
    email: data["email"],
    phone: data["phone"],
    password: hashPassword(data["password"]),
    address: [],
    wishList: [],
    profileImage: "",
    isBlocked: false,
    isVerified: false,
  );
  await MongoService.users.insertOne(
    user.toJson()
  );
  return Response.ok(
    jsonEncode({
      "success":true,
      "message":"Register Success"
    }),
    headers: {"Content-Type":"application/json"}
  );
}

Future<Response> loginUser(Request request) async {
  try {
    print("called login");
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final email = data["email"]?.toString().trim();
    final password = data["password"]?.toString();

    if (email == null || email.isEmpty ||
        password == null || password.isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          "success": false,
          "message": "Email and password are required",
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    }
    print("checked password..");
    // Find user
    final user = await MongoService.users.findOne(
      where.eq("email", email),
    );

    if (user == null) {
      return Response(
        401,
        body: jsonEncode({
          "success": false,
          "message": "Invalid email or password",
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    }
print("user founded");
    // Hash entered password
    final hashedPassword = hashPassword(password);

    // Check password
    if (user["password"] != hashedPassword) {
      return Response(
        401,
        body: jsonEncode({
          "success": false,
          "message": "Invalid email or password",
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    }

    // Generate JWT
    final token = Jwtservice.generateToken(
      userId: user["_id"].toString(),
      email: user["email"],
    );
    print("jwt created");
    final res = {
      "success": true,
      "message": "Login success",
      "token": token,
      "user": {
        "id": user["_id"].toString(),
        "name": user["name"],
        "email": user["email"],
        "phone": user["phone"],
      },
    };
    print("print response");
    print(jsonEncode(res));

    return Response.ok(
      jsonEncode(res),
      headers: {
        "Content-Type": "application/json",
      },
    );
  } catch (e) {
    print("Login error: $e");

    return Response.internalServerError(
      body: jsonEncode({
        "success": false,
        "message": "Something went wrong",
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );
  }
}

Future<Response> getUser(Request request)async{
  final users = await MongoService.users.find().toList();
  return Response.ok(
    jsonEncode(users),
    headers: {"Content-Type":"application/json"}
  );
}