import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_aura/frontend/models/cart_item_model.dart';
import 'package:shop_aura/frontend/services/authService.dart';

class CartService extends ChangeNotifier {
  CartService._internal();
  static final CartService instance = CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  bool isInCart(String name) => _items.any((item) => item.name == name);

  Future<void> fetchCartFromServer() async {
    try {
      final token = await Authservice.getToken();
      if (token == null) {
        _items.clear();
        notifyListeners();
        return;
      }
      final response = await http.get(
        Uri.parse("${Authservice.instance.baseurl}/cart/"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final List decoded = jsonDecode(response.body);
        _items.clear();
        _items.addAll(decoded.map((item) => CartItem.fromJson(item)).toList());
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching cart: $e");
    }
  }

  Future<void> addToCart({
    required String image,
    required String category,
    required String name,
    required int price,
    required int oldPrice,
  }) async {
    final existingIndex = _items.indexWhere((item) => item.name == name);

    if (existingIndex != -1) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(
        CartItem(
          image: image,
          category: category,
          name: name,
          price: price,
          oldPrice: oldPrice,
          quantity: 1,
        ),
      );
    }
    notifyListeners();

    try {
      final token = await Authservice.getToken();
      if (token != null) {
        await http.post(
          Uri.parse("${Authservice.instance.baseurl}/cart/add"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "image": image,
            "category": category,
            "name": name,
            "price": price,
            "oldPrice": oldPrice,
            "quantity": 1
          }),
        );
      }
    } catch (e) {
      debugPrint("Error adding item to cart: $e");
    }
  }

  Future<void> increaseQuantity(int index) async {
    if (index < 0 || index >= _items.length) return;
    final item = _items[index];
    item.quantity += 1;
    notifyListeners();

    try {
      final token = await Authservice.getToken();
      if (token != null) {
        await http.post(
          Uri.parse("${Authservice.instance.baseurl}/cart/update"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "name": item.name,
            "quantity": item.quantity,
          }),
        );
      }
    } catch (e) {
      debugPrint("Error increasing quantity on server: $e");
    }
  }

  Future<void> decreaseQuantity(int index) async {
    if (index < 0 || index >= _items.length) return;
    final item = _items[index];
    final String name = item.name;
    final int newQty = item.quantity - 1;

    if (item.quantity > 1) {
      item.quantity -= 1;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();

    try {
      final token = await Authservice.getToken();
      if (token != null) {
        await http.post(
          Uri.parse("${Authservice.instance.baseurl}/cart/update"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "name": name,
            "quantity": newQty,
          }),
        );
      }
    } catch (e) {
      debugPrint("Error decreasing quantity on server: $e");
    }
  }

  Future<void> removeItem(int index) async {
    if (index < 0 || index >= _items.length) return;
    final item = _items[index];
    _items.removeAt(index);
    notifyListeners();

    try {
      final token = await Authservice.getToken();
      if (token != null) {
        await http.post(
          Uri.parse("${Authservice.instance.baseurl}/cart/remove"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "name": item.name,
          }),
        );
      }
    } catch (e) {
      debugPrint("Error removing item on server: $e");
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();

    try {
      final token = await Authservice.getToken();
      if (token != null) {
        await http.post(
          Uri.parse("${Authservice.instance.baseurl}/cart/clear"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );
      }
    } catch (e) {
      debugPrint("Error clearing cart on server: $e");
    }
  }

  void clearCartLocal() {
    _items.clear();
    notifyListeners();
  }
}