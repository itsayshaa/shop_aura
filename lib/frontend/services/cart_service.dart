import 'package:flutter/foundation.dart';
import 'package:shop_aura/frontend/models/cart_item_model.dart';

/// Single app-wide cart, mirroring the WishlistService pattern.
class CartService extends ChangeNotifier {
  CartService._internal();
  static final CartService instance = CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  /// Total number of units across all cart lines (used for the header badge).
  int get itemCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  bool isInCart(String name) => _items.any((item) => item.name == name);

  /// If the item already exists, bump its quantity instead of duplicating it.
  void addToCart({
    required String image,
    required String category,
    required String name,
    required int price,
    required int oldPrice,
  }) {
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
        ),
      );
    }
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _items[index].quantity += 1;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity -= 1;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}