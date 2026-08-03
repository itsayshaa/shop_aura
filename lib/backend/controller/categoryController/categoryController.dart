import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shop_aura/backend/models/client/categoryModel.dart';
import '../../database/mongo_service.dart';

Future<Response> getCategories(Request request) async {
  final categories = await MongoService.categories.find().toList();

  return Response.ok(
    jsonEncode(categories),
    headers: {
      "Content-Type": "application/json",
    },
  );
}

Future<Response> getFeaturedCategories(Request request) async {
  final categories = await MongoService.categories
      .find(
        where.eq("isFeatured", true),
      )
      .toList();

  return Response.ok(
    jsonEncode(categories),
    headers: {
      "Content-Type": "application/json",
    },
  );
}

Future<Response> addCategory(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);
  final category = CategoryModel(
     categoriesName: data["categoriesName"],
   categoriesImage : data["categoriesImage"],
  description: data["description"],
   parentCategories : data["parentCategories"],
   status: data["status"],
   createdAt: data["createdAt"],
   updatedAt: data["updatedAt"],
  );
  await MongoService.categories.insertOne(category.toJson());

  return Response.ok(
    jsonEncode({
      "success": true,
      "message": "Category Added Successfully",
    }),
    headers: {
      "Content-Type": "application/json",
    },
  );

}
Future<Response> getCategory(Request request)async{
  final category = await MongoService.categories.find().toList();
  return Response.ok(
    jsonEncode(category),
    headers: {"Content-Type":"application/json"}
  );
}