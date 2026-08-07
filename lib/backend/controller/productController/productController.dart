import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../database/mongo_service.dart';
import 'package:shop_aura/backend/models/client/productModel.dart';

Future<Response> getProducts(Request request) async {
  try {

    print("Connected: ${MongoService.db?.isConnected}");

final products = await MongoService.products.find().take(1).toList();

print(products);
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

Future<Response> searchProducts(Request request, String query) async {
  try {
    final products = await MongoService.products.find().toList();

    final filteredProducts = products.where((product) {
      return product["name"]
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    return Response.ok(
      jsonEncode(filteredProducts),
      headers: {
        "Content-Type": "application/json",
      },
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        "success": false,
        "message": e.toString(),
      }),
      headers: {
        "Content-Type": "application/json",
      },
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
    final product = ProductsModel(
      isActive: data["isActive"],
      categoryId: ObjectId.fromHexString(data["categoryId"]),
      categoryName: data["categoryName"],
      productName: data["name"],
      brand: data["brand"],
      description: data["description"],
      productImage: List<String>.from(data["productImage"]),
      weight: data["weight"],
      size: List<String>.from(data["size"]),
      color: List<String>.from(data["color"]),
      status: data["status"],
      price: (data["price"] as num).toDouble(),
      rating: (data["rating"] as num?)?.toDouble() ?? 0,
      reviews: data["reviews"] ?? 0,
      stock: data["stock"] ?? 0,
      discountPrice: (data["discountPrice"] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isTrending: data["isTrending"] ?? false,
      isDeleted: false,
    );
    await MongoService.products.insertOne(product.toJson());

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
