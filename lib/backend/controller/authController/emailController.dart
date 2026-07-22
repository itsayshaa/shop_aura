import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shop_aura/backend/database/mongo_service.dart';
import '../../services/email_service.dart';
import '../../models/client/forgotPasswordModel.dart';
Future<Response> sendOtp(Request request) async{
  try{
    final body = jsonDecode(await request.readAsString());
    final email = body["email"]?.toString().trim();

    final existing = await MongoService.users.findOne(
      where.eq("email", email)
    );

    if(email == null || email.toString().isEmpty){
      return Response.badRequest(
        body: jsonEncode({
          'success':false,
          'message':'Email is required'
        }),

        headers: {
          "Content-Type":"application/json"
        }
      );
    }
    if(existing == null){
      return Response(
        400,
        body: jsonEncode({
          "success":false,
          "message":"This email is not registered"
        }),
        headers: {
          "Content-Type":"application/json"
        }
      );
    }
    final otp = (
      100000 + DateTime.now().microsecondsSinceEpoch % 900000).toString();
      
      
      await EmailService.sendOtp(
        email: email,
        otp: otp
      );
      final expiresAt = DateTime.now().add(
        const Duration(minutes: 5)
      );

      final forgotPassword = ForgotPassword(
        email: email,
        otp: otp,
        expiresAt: expiresAt,
        verified: false
      );
      await MongoService.password.insertOne(
        forgotPassword.toJson(),
      );
      return Response.ok(
        jsonEncode({
          'success':true,
          'message':'OTP sent successfully'
        }),

        headers: {
          "Content-Type":"application/json"
        }
      );
  }catch(e){
    print(e);
    return Response.internalServerError(
      body: jsonEncode({
        'success':false,
        'message': 'Failed to send OTP'
      }), 
      headers: {
        "Content-Type":"application/json"
      }
    );
  }
}

Future<Response> verifyOtp(Request request)async{
  try{
  final body = jsonDecode(await request.readAsString());
  final email = body["email"]?.toString().trim();
  final otp = body["otp"]?.toString().trim();

  if(email == null || email.isEmpty){
    return Response.badRequest(
      body: jsonEncode({
        "success":false,
        "message": "Email is required"
      }),
      headers:{
        "Content-Type":"application/json"
      }
    );
  }
  if(otp == null || otp.isEmpty){
    return Response.badRequest(
      body: jsonEncode({
        "success":false,
        "message": "Otp is required"
      }),
      headers:{
        "Content-Type":"application/json"
      }
    );
  }
  final forgotPassword = await MongoService.password.findOne(
    where 
      .eq('email', email)
      .eq('otp', otp)
      .eq('verified', false)
  );
  if(forgotPassword == null){
    return Response(
      400,
      body: jsonEncode({
        "success":false,
        "message": "Invalid OTP",
      }),
      headers: {
        "Content-Type":"application/json"
      }
    );
  }

  final expiresAt = forgotPassword["expiresAt"];
  final expiryDate = expiresAt is DateTime ? expiresAt : DateTime.parse(expiresAt.toString());
  if(DateTime.now().isAfter(expiryDate)){
    return Response(
      400,
      body: jsonEncode({
        "success": false,
        "message": "OTP has expired"
      }),
      headers: {
        "Content-Type":"application/json"
      }
    );
  }
  await MongoService.password.updateOne(
    where.eq('_id', forgotPassword['_id']),
    modify.set('verified', true)
  );
  return Response.ok(
    jsonEncode({
      "success":true,
      "message":"otp verfied success"
    }),
    headers: {
      "Content-Type":"application/json"
    }
  );
}catch(e){
  print("Verify Otp error: $e");
  return Response.internalServerError(
    body: jsonEncode({
      "success":false,
      "message": "Failed to verify OTP"
    }),
    headers: {
      "Content-Type":"application/json"
    }
  );
}
}