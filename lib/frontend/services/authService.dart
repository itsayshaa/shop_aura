import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_aura/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
class Authservice extends ChangeNotifier {
  Authservice._internal();
  static final Authservice instance = Authservice._internal();
  // final env = DotEnv()..load();
  bool _isLoggedIn = false;
  String? _userName;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String baseUrl = Apiconfig.baseUrl;
  Future<bool> login({required String email, required String password})async{
    try{
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode({
          "email":email,
          "password":password
        })
      );
      final body = jsonDecode(response.body);
      if(response.statusCode == 200 || body["success"] == true){
        final token = body["token"];
        final userName = body["user"]["name"];
        final userEmail = body["user"]["email"];
        final userPhone = body["user"]["phone"];

        final createdAt = body["user"]["createdAt"];
        DateTime date = DateTime.parse(createdAt);
        final joinedAt = DateFormat('MMMM d, yyyy').format(date);
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString("jwt_token", token);
        await prefs.setString("user_name", userName);
        await prefs.setString("user_email", userEmail);
        await prefs.setString("user_phone", userPhone);
        await prefs.setString("createdAt", joinedAt);

        _isLoggedIn = true;
        _userName = body["name"];
        _userEmail = body["email"];
        notifyListeners();
        return true;
      }
      final message = body["message"] ?? "Invalid email or password";
      throw Exception(message);
    }catch(e,stackTrace){
      print("error $e");
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
      Uri.parse("$baseUrl/register"),
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

  static Future<void> logOut()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwt_token");
    await prefs.remove("user_name");
    await prefs.remove("user_email");
    await prefs.remove("user_phone");
  }
}