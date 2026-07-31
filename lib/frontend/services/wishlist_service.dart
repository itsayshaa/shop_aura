import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_aura/frontend/models/wishlist_item_model.dart';
import 'package:shop_aura/frontend/services/authService.dart';

class WishlistService extends ChangeNotifier {
  WishlistService._internal();
  static final WishlistService instance = WishlistService._internal();

  final List<WishlistItem> _items = [];

  List<WishlistItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  bool isWishlisted(String name) {
    return _items.any((item) => item.name == name);
  }

  Future<void> fetchWishlistFromServer() async {
    try {
      final token = await Authservice.getToken();
      if (token == null) {
        _items.clear();
        notifyListeners();
        return;
      }
      final response = await http.get(
        Uri.parse("${Authservice.instance.baseurl}/wishlist/"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final List decoded = jsonDecode(response.body);
        _items.clear();
        _items.addAll(decoded.map((item) => WishlistItem.fromJson(item)).toList());
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching wishlist: $e");
    }
  }

  bool toggle({
    required String image,
    required String category,
    required String name,
    required double rating,
    required int reviews,
    required int price,
    required int oldPrice,
    required int discount,
  }) {
    final existingIndex = _items.indexWhere((item) => item.name == name);
    bool added = false;

    if (existingIndex != -1) {
      _items.removeAt(existingIndex);
      added = false;
    } else {
      _items.add(
        WishlistItem(
          image: image,
          category: category,
          name: name,
          rating: rating,
          reviews: reviews,
          price: price,
          oldPrice: oldPrice,
          discount: discount,
        ),
      );
      added = true;
    }
    notifyListeners();

    // Call server in background
    _syncToggleOnServer(
      image: image,
      category: category,
      name: name,
      rating: rating,
      reviews: reviews,
      price: price,
      oldPrice: oldPrice,
      discount: discount,
    );

    return added;
  }

  Future<void> _syncToggleOnServer({
    required String image,
    required String category,
    required String name,
    required double rating,
    required int reviews,
    required int price,
    required int oldPrice,
    required int discount,
  }) async {
    try {
      final token = await Authservice.getToken();
      if (token != null) {
        await http.post(
          Uri.parse("${Authservice.instance.baseurl}/wishlist/toggle"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "image": image,
            "category": category,
            "name": name,
            "rating": rating,
            "reviews": reviews,
            "price": price,
            "oldPrice": oldPrice,
            "discount": discount,
          }),
        );
      }
    } catch (e) {
      debugPrint("Error syncing wishlist toggle: $e");
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
          Uri.parse("${Authservice.instance.baseurl}/wishlist/remove"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({"name": item.name}),
        );
      }
    } catch (e) {
      debugPrint("Error removing wishlist item: $e");
    }
  }

  Future<void> removeByName(String name) async {
    _items.removeWhere((item) => item.name == name);
    notifyListeners();

    try {
      final token = await Authservice.getToken();
      if (token != null) {
        await http.post(
          Uri.parse("${Authservice.instance.baseurl}/wishlist/remove"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({"name": name}),
        );
      }
    } catch (e) {
      debugPrint("Error removing wishlist item by name: $e");
    }
  }

  Future<void> clearWishlist() async {
    _items.clear();
    notifyListeners();

    try {
      final token = await Authservice.getToken();
      if (token != null) {
        await http.post(
          Uri.parse("${Authservice.instance.baseurl}/wishlist/clear"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );
      }
    } catch (e) {
      debugPrint("Error clearing wishlist: $e");
    }
  }

  void clearWishlistLocal() {
    _items.clear();
    notifyListeners();
  }
}