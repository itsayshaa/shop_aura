import 'package:shop_aura/backend/models/client/categoryModel.dart';
import 'package:shop_aura/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class CategoryService extends ChangeNotifier{
  String? get baseUrl => Apiconfig.baseUrl;

  Future<List<CategoryModel>> getCategories()async{
    final response = await http.get(
      Uri.parse("$baseUrl/category/")
    );
    if(response.statusCode == 200){
      final List data = jsonDecode(response.body);
      return data
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    }
    throw Exception("Failed to load products");
  }
}