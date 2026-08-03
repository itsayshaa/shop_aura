import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shop_aura/backend/database/mongo_service.dart';
import 'package:shop_aura/backend/services/jwtService.dart';

Future<Response> getCart(Request request) async {
  try {
    final userId = Jwtservice.getUserIdFromRequest(request);
    if (userId == null) {
      return Response(401, body: jsonEncode({"success": false, "message": "Unauthorized"}), headers: {"Content-Type": "application/json"});
    }

    final cart = await MongoService.cart.findOne(where.eq("userId", userId));
    final items = cart != null ? cart["items"] ?? [] : [];

    return Response.ok(jsonEncode(items), headers: {"Content-Type": "application/json"});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}

Future<Response> addToCart(Request request) async {
  try {
    final userId = Jwtservice.getUserIdFromRequest(request);
    if (userId == null) {
      return Response(401, body: jsonEncode({"success": false, "message": "Unauthorized"}), headers: {"Content-Type": "application/json"});
    }

    final body = await request.readAsString();
    final data = jsonDecode(body);

    final String image = data["image"] ?? "";
    final String category = data["category"] ?? "";
    final String name = data["name"] ?? "";
    final int price = data["price"] ?? 0;
    final int oldPrice = data["oldPrice"] ?? 0;
    final int quantity = data["quantity"] ?? 1;

    if (name.isEmpty) {
      return Response(400, body: jsonEncode({"success": false, "message": "Product name is required"}), headers: {"Content-Type": "application/json"});
    }

    var cart = await MongoService.cart.findOne(where.eq("userId", userId));

    if (cart == null) {
      // Create new cart
      final newCart = {
        "userId": userId,
        "items": [
          {
            "image": image,
            "category": category,
            "name": name,
            "price": price,
            "oldPrice": oldPrice,
            "quantity": quantity
          }
        ]
      };
      await MongoService.cart.insertOne(newCart);
    } else {
      List items = List.from(cart["items"] ?? []);
      final existingIndex = items.indexWhere((item) => item["name"] == name);

      if (existingIndex != -1) {
        items[existingIndex]["quantity"] = (items[existingIndex]["quantity"] ?? 1) + quantity;
      } else {
        items.add({
          "image": image,
          "category": category,
          "name": name,
          "price": price,
          "oldPrice": oldPrice,
          "quantity": quantity
        });
      }

      await MongoService.cart.updateOne(
        where.eq("userId", userId),
        modify.set("items", items),
      );
    }

    return Response.ok(jsonEncode({"success": true, "message": "Item added to cart successfully"}), headers: {"Content-Type": "application/json"});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}

Future<Response> updateQuantity(Request request) async {
  try {
    final userId = Jwtservice.getUserIdFromRequest(request);
    if (userId == null) {
      return Response(401, body: jsonEncode({"success": false, "message": "Unauthorized"}), headers: {"Content-Type": "application/json"});
    }

    final body = await request.readAsString();
    final data = jsonDecode(body);

    final String name = data["name"] ?? "";
    final int quantity = data["quantity"] ?? 0;

    if (name.isEmpty) {
      return Response(400, body: jsonEncode({"success": false, "message": "Product name is required"}), headers: {"Content-Type": "application/json"});
    }

    var cart = await MongoService.cart.findOne(where.eq("userId", userId));
    if (cart == null) {
      return Response(404, body: jsonEncode({"success": false, "message": "Cart not found"}), headers: {"Content-Type": "application/json"});
    }

    List items = List.from(cart["items"] ?? []);
    final index = items.indexWhere((item) => item["name"] == name);

    if (index != -1) {
      if (quantity <= 0) {
        items.removeAt(index);
      } else {
        items[index]["quantity"] = quantity;
      }

      await MongoService.cart.updateOne(
        where.eq("userId", userId),
        modify.set("items", items),
      );
      return Response.ok(jsonEncode({"success": true, "message": "Quantity updated"}), headers: {"Content-Type": "application/json"});
    } else {
      return Response(404, body: jsonEncode({"success": false, "message": "Item not found in cart"}), headers: {"Content-Type": "application/json"});
    }
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}

Future<Response> removeFromCart(Request request) async {
  try {
    final userId = Jwtservice.getUserIdFromRequest(request);
    if (userId == null) {
      return Response(401, body: jsonEncode({"success": false, "message": "Unauthorized"}), headers: {"Content-Type": "application/json"});
    }

    final body = await request.readAsString();
    final data = jsonDecode(body);
    final String name = data["name"] ?? "";

    if (name.isEmpty) {
      return Response(400, body: jsonEncode({"success": false, "message": "Product name is required"}), headers: {"Content-Type": "application/json"});
    }

    var cart = await MongoService.cart.findOne(where.eq("userId", userId));
    if (cart == null) {
      return Response(404, body: jsonEncode({"success": false, "message": "Cart not found"}), headers: {"Content-Type": "application/json"});
    }

    List items = List.from(cart["items"] ?? []);
    items.removeWhere((item) => item["name"] == name);

    await MongoService.cart.updateOne(
      where.eq("userId", userId),
      modify.set("items", items),
    );

    return Response.ok(jsonEncode({"success": true, "message": "Item removed from cart"}), headers: {"Content-Type": "application/json"});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}

Future<Response> clearCart(Request request) async {
  try {
    final userId = Jwtservice.getUserIdFromRequest(request);
    if (userId == null) {
      return Response(401, body: jsonEncode({"success": false, "message": "Unauthorized"}), headers: {"Content-Type": "application/json"});
    }

    await MongoService.cart.updateOne(
      where.eq("userId", userId),
      modify.set("items", []),
    );

    return Response.ok(jsonEncode({"success": true, "message": "Cart cleared successfully"}), headers: {"Content-Type": "application/json"});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({"success": false, "message": e.toString()}), headers: {"Content-Type": "application/json"});
  }
}
