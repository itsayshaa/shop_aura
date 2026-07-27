import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shop_aura/backend/database/mongo_service.dart';

Future<Response> changePassword(Request request) async {
  try {
    final body = jsonDecode(
      await request.readAsString(),
    );

    final email = body["email"]?.toString().trim();
    final newPassword = body["newPassword"]?.toString();
    
    if (email == null || email.isEmpty) {
      return Response.badRequest(
        body: jsonEncode({
          "success": false,
          "message": "Email is required",
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    }
    if (newPassword == null || newPassword.isEmpty) {
      return Response.badRequest(
        body: jsonEncode({
          "success": false,
          "message": "New password is required",
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    }
    final user = await MongoService.users.findOne(
      where.eq("email", email),
    );

    if (user == null) {
      return Response(
        400,
        body: jsonEncode({
          "success": false,
          "message": "Invalid user",
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    }
    final verifiedOtp =
        await MongoService.password.findOne(
      where
          .eq("email", email)
          .eq("verified", true),
    );

    if (verifiedOtp == null) {
      return Response(
        400,
        body: jsonEncode({
          "success": false,
          "message": "Please verify OTP first",
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );
    }

    await MongoService.users.updateOne(
      where.eq("email", email),
      modify.set(
        "password",
        newPassword,
      ),
    );
    await MongoService.password.deleteOne(
      where.eq("_id", verifiedOtp["_id"]),
    );

    return Response.ok(
      jsonEncode({
        "success": true,
        "message": "Password changed successfully",
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );
  } catch (e) {
    print("Change Password Error: $e");

    return Response.internalServerError(
      body: jsonEncode({
        "success": false,
        "message": "Failed to change password",
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );
  }
}