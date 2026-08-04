import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_aura/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
class Authservice extends ChangeNotifier {
  Authservice._internal();
  static final Authservice instance = Authservice._internal();
  bool _isLoggedIn = false;
  String? _userName;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get baseurl => Apiconfig.baseUrl;
  Future<bool> login({required String email, required String password})async{
    try{
      final response = await http.post(
        Uri.parse("$baseurl/auth/login"),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode({
          "email":email,
          "password":password
        })
      );
      final body = jsonDecode(response.body);
      print(body);
      if(response.statusCode == 200 || body["success"] == true){
        final token = body["token"];
        final userName = body["user"]["name"];
        final userEmail = body["user"]["email"];
        final userPhone = body["user"]["phone"];
        final role = body["user"]["role"];
        final userId = body["user"]["id"].toString();

        final createdAt = body["user"]["createdAt"];
        DateTime date = DateTime.parse(createdAt);
        final joinedAt = DateFormat('MMMM d, yyyy').format(date);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("userId", userId);
        await prefs.setString("jwt_token", token);
        await prefs.setString("user_name", userName);
        await prefs.setString("user_email", userEmail);
        await prefs.setString("user_phone", userPhone);
        await prefs.setString("createdAt", joinedAt);
        await prefs.setString("user_role", role);
        _isLoggedIn = true;
        _userName = body["name"];
        _userEmail = body["email"];
        notifyListeners();
        return true;
      }
      final message = body["message"] ?? "Invalid email or password";
      throw Exception(message);
    }catch(e){
      debugPrint("error $e");
      rethrow;
    }
  }

static Future<bool> isLogged()async{
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("jwt_token");
  if(token == null || token.isEmpty){
    return false;
  }
  return true;
}

static Future<String?> getToken()async{
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("jwt_token");
}

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password
  })async{
    final response = await http.post(
      Uri.parse("$baseurl/auth/register"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({
        "name":name,
        "email":email,
        "phone":phone,
        "password":password
      })
    );
    final body = jsonDecode(response.body);
    if(response.statusCode == 200 || response.statusCode == 201){
      return true;
    }else{
      throw Exception(body["message"]);
    }
  }

  static Future<void> logOut(BuildContext context)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwt_token");
    await prefs.remove("user_name");
    await prefs.remove("user_email");
    await prefs.remove("user_phone");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShopAuraApp()));
  }

  static Future<bool> updateProfile({
  required String name,
  required String phone,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("jwt_token");

    final response = await http.put(
      Uri.parse("${Apiconfig.baseUrl}/auth/profile"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "name": name,
        "phone": phone,
      }),
    );

    if (response.statusCode == 200) {
      await prefs.setString("user_name", name);
      await prefs.setString("user_phone", phone);
      return true;
    }

    return false;
  } catch (e) {
    print(e);
    return false;
  }
}
}