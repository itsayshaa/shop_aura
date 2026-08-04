import 'package:shop_aura/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop_aura/backend/models/client/cartModel/cartModel.dart';

class CartService extends ChangeNotifier {
  String? get baseUrl => Apiconfig.baseUrl;


  static final CartService instance = CartService._internal();

  CartService._internal();



  Future<void> addToCart({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/cart/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "productId": productId,
        "quantity": quantity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add cart");
    }
  }
  // Future<void> fetchCartFromServer() async {
  //   try {
  //     final token = await Authservice.getToken();
  //     if (token == null) {
  //       _items.clear();
  //       notifyListeners();
  //       return;
  //     }
  //     final response = await http.get(
  //       Uri.parse("${Authservice.instance.baseurl}/cart/"),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final List decoded = jsonDecode(response.body);
  //       _items.clear();
  //       _items.addAll(decoded.map((item) => CartItem.fromJson(item)).toList());
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     debugPrint("Error fetching cart: $e");
  //   }
  // }

  Future<CartModel> getCart(String userId) async {
    final response = await http.get(Uri.parse("$baseUrl/cart/$userId"));

    print("BODY => ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return CartModel.fromJson(data);
    }

    throw Exception("Cart loading failed");
  }

  Future<void> increaseQuantity({
    required String userId,
    required String productId,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/cart/increase"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "productId": productId}),
    );
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception("Failed to increase quantity");
    }

    notifyListeners();
  }

  Future<void> decreaseQuantity({
    required String userId,
    required String productId,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/cart/decrease"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "productId": productId}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to decrease quantity");
    }

    notifyListeners();
  }

  Future<void> removeItem({
    required String userId,
    required String productId,
  }) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/cart/remove"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "productId": productId}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to remove item");
    }

    notifyListeners();
  }
}
