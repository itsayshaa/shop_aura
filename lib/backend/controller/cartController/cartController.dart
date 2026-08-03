  import 'package:shelf/shelf.dart';
  import 'dart:convert';
  import 'package:mongo_dart/mongo_dart.dart';
  import 'package:shop_aura/backend/database/mongo_service.dart';

  Future<Response> addToCart(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      print(data);
      final userId =ObjectId.fromHexString(data["userId"]);
      final productId =ObjectId.fromHexString(data["productId"]);
      
      final quantity = data["quantity"];

      final product = await MongoService.products.findOne(
        where.id(productId),
      );

      if (product == null) {
        return Response.notFound("Product not found");
      }

      final cart = await MongoService.cart.findOne(
        where.eq("userId", userId),
      );
      final productid = product["_id"] as ObjectId;
      if (cart == null) {
        await MongoService.cart.insertOne({
          "userId": userId,
          "products": [
            {
              "productId": productid,
              "name": product["name"],
              "image": product["images"][0]["url"],
              "price": product["price"],
              "quantity": quantity,
              "subtotal": product["price"] * quantity,
            }
          ]
        });
      } else {
        List products = cart["products"];

        bool found = false;

        for (var item in products) {
          if (item["productId"] as ObjectId == productId) {
            item["quantity"] += quantity;
            item["subtotal"] =
                item["quantity"] * item["price"];

            found = true;
            break;
          }
        }

        if (!found) {
          products.add({
            "productId": productid,
            "name": product["name"],
            "image": product["images"][0]["url"],
            "price": product["price"],
            "quantity": quantity,
            "subtotal": product["price"] * quantity,
          });
        }

        await MongoService.cart.updateOne(
          where.eq("userId", userId),
          modify.set("products", products),
        );
      }

      return Response.ok(
        jsonEncode({
          "success": true,
          "message": "Added to cart"
        }),
        headers: {
          "Content-Type": "application/json"
        },
      );
    } catch (e, stackTrace) {
  print("ERROR: $e");
  print(stackTrace);

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
 Future<Response> getCart(Request request, String id) async {
  try {

    final userId = ObjectId.fromHexString(id);

    final cart = await MongoService.cart.findOne(
      where.eq("userId", userId),
    );

    print("CART DATA => $cart");

    if(cart == null){
      return Response.ok(
        jsonEncode({
          "success":true,
          "products":[],
          "subtotal":0
        }),
        headers:{
          "Content-Type":"application/json"
        }
      );
    }


    double subtotal = 0;

    for(final item in cart["products"]){
      subtotal += (item["subtotal"] ?? 0).toDouble();
    }


    cart["subtotal"] = subtotal;


    return Response.ok(
      jsonEncode(cart),
      headers:{
        "Content-Type":"application/json"
      }
    );


 } catch (e, stackTrace) {
  print("ERROR: $e");
  print(stackTrace);

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
Future<Response> getAll(Request request)async{
  final cart = await MongoService.cart.find().toList();
  return Response.ok(
    jsonEncode(cart),
    headers: {"Content-Type":"application/json"}
  );
}
Future<Response> increaseQuantity(Request request) async {
  try {
    final body = jsonDecode(await request.readAsString());

    final userId = ObjectId.fromHexString(body["userId"]);
    final productId = ObjectId.fromHexString(body["productId"]);

    final cart = await MongoService.cart.findOne(
      where.eq("userId", userId),
    );

    if (cart == null) {
      return Response.notFound(
        jsonEncode({
          "success": false,
          "message": "Cart not found",
        }),
      );
    }

    List products = cart["products"];

    bool found = false;

    for (var item in products) {
      if (item["productId"] == productId) {
        item["quantity"] += 1;
        item["subtotal"] =
            item["price"] * item["quantity"];
        found = true;
        break;
      }
    }

    if (!found) {
      return Response.notFound(
        jsonEncode({
          "success": false,
          "message": "Product not found in cart",
        }),
      );
    }

    await MongoService.cart.updateOne(
      where.eq("userId", userId),
      modify.set("products", products),
    );

    return Response.ok(
      jsonEncode({
        "success": true,
        "message": "Quantity increased",
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );
  } catch (e, stackTrace) {
  print("ERROR: $e");
  print(stackTrace);

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
Future<Response> decreaseQuantity(Request request) async {
  try {
    final body = jsonDecode(await request.readAsString());

    final userId = ObjectId.fromHexString(body["userId"]);
    final productId = ObjectId.fromHexString(body["productId"]);

    final cart = await MongoService.cart.findOne(
      where.eq("userId", userId),
    );

    if (cart == null) {
      return Response.notFound(
        jsonEncode({
          "success": false,
          "message": "Cart not found",
        }),
      );
    }

    List products = cart["products"];

    products.removeWhere((item) {
      if (item["productId"] == productId) {
        item["quantity"]--;

        if (item["quantity"] <= 0) {
          return true;
        }

        item["subtotal"] =
            item["price"] * item["quantity"];
      }
      return false;
    });

    await MongoService.cart.updateOne(
      where.eq("userId", userId),
      modify.set("products", products),
    );

    return Response.ok(
      jsonEncode({
        "success": true,
        "message": "Quantity decreased",
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );
  } catch (e, stackTrace) {
  print("ERROR: $e");
  print(stackTrace);

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

Future<Response> removeItem(Request request) async {
  try {
    final body = jsonDecode(await request.readAsString());

    final userId = ObjectId.fromHexString(body["userId"]);
    final productId = ObjectId.fromHexString(body["productId"]);

    final cart = await MongoService.cart.findOne(
      where.eq("userId", userId),
    );

    if (cart == null) {
      return Response.notFound(
        jsonEncode({
          "success": false,
          "message": "Cart not found",
        }),
      );
    }

    List products = cart["products"];

    products.removeWhere(
      (item) => item["productId"] == productId,
    );

    await MongoService.cart.updateOne(
      where.eq("userId", userId),
      modify.set("products", products),
    );

    return Response.ok(
      jsonEncode({
        "success": true,
        "message": "Item removed",
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );
  } catch (e, stackTrace) {
  print("ERROR: $e");
  print(stackTrace);

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