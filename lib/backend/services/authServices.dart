// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:shop_aura/main.dart';

// class Authservices {
//   static Future<bool> login({
//   required String email,
//   required String password
//   }) async{
//     try{
//       final baseUrl =  Apiconfig.baseUrl;
//       final response = await http.post(
//         Uri.parse("$baseUrl/auth/login"),
//         headers:{"Content-Type":"application/json"},
//         body:jsonEncode({
//           "email":email,
//           "password":password
//         })
//       );
//       final data = jsonDecode(response.body);
//       if(response.statusCode == 200 || data["success"] == true){
//         final token = data["token"];
//         final prefs = await SharedPreferences.getInstance();

//         await prefs.setString(
//           "jwt_token",
//           token
//         );
//         await prefs.setString(
//           "user_name", 
//           data["user"]["name"]
//           );
//         await prefs.setString(
//           "user_email",
//           data["user"]["email"]
//         );
//         await prefs.setString(
//           "user_phone",
//           data["user"]["phone"]
//         );
//         return true;
//       }
//       return false;
//     }catch(e){
//       print("Login ereerror $e");
//       return false;
//     }
//   }

//   static Future<bool> isLoggedIn()async{
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("jwt_token");
//     if(token == null || token.isEmpty){
//       return false;
//     }
//     return true;
//   }

//   static Future<String?> getToken()async{
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("jwt_token");
//   }
//   static Future<void> logOut(BuildContext context)async{
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove("jwt_token");
//     await prefs.remove("user_name");
//     await prefs.remove("user_email");
//     await prefs.remove("user_phone");
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShopAuraApp()));
//   }
// }