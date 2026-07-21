import 'package:flutter/foundation.dart';
import 'package:shop_aura/frontend/models/wishlist_item_model.dart';

/// A single app-wide wishlist, mirroring how CartService is structured.
class WishlistService extends ChangeNotifier {
  WishlistService._internal();
  static final WishlistService instance = WishlistService._internal();

  final List<WishlistItem> _items = [];

  List<WishlistItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  bool isWishlisted(String name) {
    return _items.any((item) => item.name == name);
  }

  /// Adds the item if it isn't already wishlisted, otherwise removes it.
  /// Returns the new wishlisted state (true = now in wishlist).
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

    if (existingIndex != -1) {
      _items.removeAt(existingIndex);
      notifyListeners();
      return false;
    }

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
    notifyListeners();
    return true;
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void removeByName(String name) {
    _items.removeWhere((item) => item.name == name);
    notifyListeners();
  }

  void clearWishlist() {
    _items.clear();
    notifyListeners();
  }
}