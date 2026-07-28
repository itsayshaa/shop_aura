import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../database/mongo_service.dart';

Future<Response> getProducts(Request request) async {
  try {
    final products = await MongoService.products.find().toList();
    return Response.ok(
      jsonEncode(products),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({"success": false, "message": e.toString()}),
      headers: {"Content-Type": "application/json"},
    );
  }
}

Future<Response> getProduct(Request request) async {
  try {
    final id = request.params["id"];

    if (id == null || id.isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          "success": false,
          "message": "Product id is required",
        }),
        headers: {"Content-Type": "application/json"},
      );
    }

    final product = await MongoService.products.findOne(
      where.id(ObjectId.fromHexString(id)),
    );

    if (product == null) {
      return Response(
        404,
        body: jsonEncode({"success": false, "message": "Product not found"}),
        headers: {"Content-Type": "application/json"},
      );
    }

    return Response.ok(
      jsonEncode(product),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({"success": false, "message": e.toString()}),
      headers: {"Content-Type": "application/json"},
    );
  }
}

Future<Response> getProductsByCategory(Request request) async {
  try {
    final categoryId = request.params["categoryId"];

    if (categoryId == null || categoryId.isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          "success": false,
          "message": "Category id is required",
        }),
        headers: {"Content-Type": "application/json"},
      );
    }

    final products = await MongoService.products
        .find(where.eq("categoryId", ObjectId.fromHexString(categoryId)))
        .toList();

    return Response.ok(
      jsonEncode(products),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({"success": false, "message": e.toString()}),
      headers: {"Content-Type": "application/json"},
    );
  }
}

Future<Response> addProduct(Request request) async {
  try {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    await MongoService.products.insertOne({
      "categoryId": ObjectId.fromHexString(data["categoryId"]),
      "name": data["name"],
      "brand": data["brand"],
      "description": data["description"],
      "images": data["images"],
      "price": data["price"],
      "oldPrice": data["oldPrice"],
      "rating": data["rating"],
      "reviews": data["reviews"],
      "stock": data["stock"],
      "discount": data["discount"],
      "isFeatured": data["isFeatured"] ?? false,
      "isBestSeller": data["isBestSeller"] ?? false,
      "isFlashSale": data["isFlashSale"] ?? false,
    });

    return Response.ok(
      jsonEncode({"success": true, "message": "Product added successfully"}),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({"success": false, "message": e.toString()}),
      headers: {"Content-Type": "application/json"},
    );
  }
}
