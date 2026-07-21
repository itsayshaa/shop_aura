import 'dart:convert';
import 'package:shelf/shelf.dart';

import '../../services/email_service.dart';

Future<Response> sendOtp(Request request) async{
  try{
    final body = jsonDecode(await request.readAsString());
    final email = body["email"];
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
    final otp = (
      100000 + DateTime.now().microsecondsSinceEpoch % 900000).toString();
      await EmailService.sendOtp(
        email: email,
        otp: otp
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