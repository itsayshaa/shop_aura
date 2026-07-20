import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dotenv/dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  String get baseUrl => dotenv.env["API_URL"] ?? "";
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
      if(response.statusCode == 200){
        _isLoggedIn = true;
        _userName = body["name"];
        _userEmail = body["email"];
        notifyListeners();
        return true;
      }
      throw Exception(body["message"]);
    }catch(e,stackTrace){
      debugPrint("ERROR : $e");
      debugPrintStack(stackTrace:stackTrace);
      rethrow;
        }
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
}