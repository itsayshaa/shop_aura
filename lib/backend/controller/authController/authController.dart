import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shop_aura/backend/database/mongo_service.dart';
import 'package:crypto/crypto.dart';
import 'package:shop_aura/backend/models/client/userModel.dart';
import 'package:shop_aura/backend/services/jwtService.dart';

String hashPassword(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}

Future<Response> registerUser(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);

  final existing = await MongoService.users.findOne(
    where.eq("email", data["email"]),
  );
  if (existing != null) {
    return Response(
      400,
      body: jsonEncode({"success": false, "message": "Email already exist"}),
      headers: {"Content-Type": "application/json"},
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
    isActive: "Active",
    isBlocked: false,
    isVerified: false,
    createdAt: DateTime.now().toUtc().toIso8601String(),
    role: "user",
  );
  await MongoService.users.insertOne(user.toJson());
  return Response.ok(
    jsonEncode({"success": true, "message": "Register Success"}),
    headers: {"Content-Type": "application/json"},
  );
}

Future<Response> loginUser(Request request) async {
  try {
    print("called login");
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final email = data["email"]?.toString().trim();
    final password = data["password"]?.toString();

    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          "success": false,
          "message": "Email and password are required",
        }),
        headers: {"Content-Type": "application/json"},
      );
    }
    print("checked password..");
    final user = await MongoService.users.findOne(where.eq("email", email));
    print("user fetched");
    if (user == null) {
      return Response(
        401,
        body: jsonEncode({
          "success": false,
          "message": "Invalid email or password",
        }),
        headers: {"Content-Type": "application/json"},
      );
    }
    print("user founded");
    final hashedPassword = hashPassword(password);

    if (user["password"] != hashedPassword) {
      return Response(
        401,
        body: jsonEncode({
          "success": false,
          "message": "Invalid email or password",
        }),
        headers: {"Content-Type": "application/json"},
      );
    }

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
        "id": user["_id"].toHexString(),
        "name": user["name"],
        "email": user["email"],
        "phone": user["phone"],
        "createdAt": user["createdAt"],
        "role": user["role"],
      },
    };

    return Response.ok(
      jsonEncode(res),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    print("Login error: $e");

    return Response.internalServerError(
      body: jsonEncode({"success": false, "message": "Something went wrong"}),
      headers: {"Content-Type": "application/json"},
    );
  }
}

Future<Response> updateProfile(Request request) async {
  try {
    final body = jsonDecode(await request.readAsString());

    final token = request.headers["authorization"]?.replaceFirst("Bearer ", "");

    if (token == null) {
      return Response.forbidden(
        jsonEncode({"success": false, "message": "Token missing"}),
      );
    }

    final payload = Jwtservice.verifyToken(token);

    final email = payload?["email"];

    final name = body["name"];
    final phone = body["phone"];

    await MongoService.users.updateOne(
      where.eq("email", email),
      modify
        ..set("name", name)
        ..set("phone", phone),
    );

    return Response.ok(
      jsonEncode({"success": true, "message": "Profile updated"}),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({"success": false, "message": e.toString()}),
    );
  }
}

String formatDate(String date) {
  final dateTime = DateTime.parse(date);
  return DateFormat("MMMM d, yyyy").format(dateTime);
}

Future<Response> getUser(Request request) async {
  final users = await MongoService.users.find().toList();
  final userList = users
      .where((user) => user["role"] == "user")
      .map(
        (user) => {
          "name": user["name"],
          "email": user["email"],
          "phone": user["phone"],
          "joinedAt": formatDate(user["createdAt"]),
          "address": user["address"],
          "status": user["status"],
          "isVerified": user["isVerified"],
          "isBlocked": user["isBlocked"],
          "role": user["role"],
        },
      )
      .toList();
  return Response.ok(
    jsonEncode(userList),
    headers: {"Content-Type": "application/json"},
  );
}
