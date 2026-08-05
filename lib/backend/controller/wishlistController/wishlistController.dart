import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shop_aura/backend/database/mongo_service.dart';

Future<Response> getWishlist(Request request,String id) async {
  try {
    final userId = ObjectId.fromHexString(id);

    final wishlist = await MongoService.wishlists.findOne(where.eq("userId", userId));
    final items = wishlist != null ? wishlist["items"] ?? [] : [];

    return Response.ok(jsonEncode(items), headers: {"Content-Type": "application/json"});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}

Future<Response> toggleWishlist(Request request) async {
  try {
    final body = await request.readAsString();
    final data = jsonDecode(body);
    final userId = data["userId"];
    if (userId == null) {
      return Response(401, body: jsonEncode({"success": false, "message": "Unauthorized"}), headers: {"Content-Type": "application/json"});
    }

    final String image = data["image"] ?? "";
    final String category = data["category"] ?? "";
    final String name = data["name"] ?? "";
    final double rating = (data["rating"] ?? 0.0).toDouble();
    final int reviews = data["reviews"] ?? 0;
    final int price = data["price"] ?? 0;
    final int oldPrice = data["oldPrice"] ?? 0;
    final int discount = data["discount"] ?? 0;

    if (name.isEmpty) {
      return Response(400, body: jsonEncode({"success": false, "message": "Product name is required"}), headers: {"Content-Type": "application/json"});
    }

    var wishlist = await MongoService.wishlists.findOne(where.eq("userId", userId));
    bool isWishlisted = false;

    if (wishlist == null) {
      // Create new wishlist
      final newWishlist = {
        "userId": userId,
        "items": [
          {
            "image": image,
            "category": category,
            "name": name,
            "rating": rating,
            "reviews": reviews,
            "price": price,
            "oldPrice": oldPrice,
            "discount": discount
          }
        ]
      };
      await MongoService.wishlists.insertOne(newWishlist);
      isWishlisted = true;
    } else {
      List items = List.from(wishlist["items"] ?? []);
      final existingIndex = items.indexWhere((item) => item["name"] == name);

      if (existingIndex != -1) {
        // Remove item
        items.removeAt(existingIndex);
        isWishlisted = false;
      } else {
        // Add item
        items.add({
          "image": image,
          "category": category,
          "name": name,
          "rating": rating,
          "reviews": reviews,
          "price": price,
          "oldPrice": oldPrice,
          "discount": discount
        });
        isWishlisted = true;
      }

      await MongoService.wishlists.updateOne(
        where.eq("userId", userId),
        modify.set("items", items),
      );
    }

    return Response.ok(
      jsonEncode({
        "success": true,
        "message": isWishlisted ? "Added to wishlist" : "Removed from wishlist",
        "isWishlisted": isWishlisted
      }),
      headers: {"Content-Type": "application/json"},
    );
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}

Future<Response> removeFromWishlist(Request request) async {
  try {
        final body = await request.readAsString();
    final data = jsonDecode(body);
    final userId = data["userId"];
    if (userId == null) {
      return Response(401, body: jsonEncode({"success": false, "message": "Unauthorized"}), headers: {"Content-Type": "application/json"});
    }

    final String name = data["name"] ?? "";

    if (name.isEmpty) {
      return Response(400, body: jsonEncode({"success": false, "message": "Product name is required"}), headers: {"Content-Type": "application/json"});
    }

    var wishlist = await MongoService.wishlists.findOne(where.eq("userId", userId));
    if (wishlist == null) {
      return Response(404, body: jsonEncode({"success": false, "message": "Wishlist not found"}), headers: {"Content-Type": "application/json"});
    }

    List items = List.from(wishlist["items"] ?? []);
    items.removeWhere((item) => item["name"] == name);

    await MongoService.wishlists.updateOne(
      where.eq("userId", userId),
      modify.set("items", items),
    );

    return Response.ok(jsonEncode({"success": true, "message": "Item removed from wishlist"}), headers: {"Content-Type": "application/json"});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}

Future<Response> clearWishlist(Request request) async {
  try {
    final body = await request.readAsString();
    final data = jsonDecode(body);
    final userId = data["userId"];

    await MongoService.wishlists.updateOne(
      where.eq("userId", userId),
      modify.set("items", []),
    );

    return Response.ok(jsonEncode({"success": true, "message": "Wishlist cleared successfully"}), headers: {"Content-Type": "application/json"});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}
