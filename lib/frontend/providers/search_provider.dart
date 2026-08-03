import 'package:flutter/foundation.dart';
import 'package:shop_aura/backend/models/client/productModel.dart';
import 'package:shop_aura/frontend/services/product_service.dart';

class SearchProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<ProductsModel> _results = [];
  bool _isSearching = false;
  String _query = "";

  List<ProductsModel> get results => _results;
  bool get isSearching => _isSearching;
  String get query => _query;

  Future<void> search(String value) async {
    _query = value;

    if (value.trim().isEmpty) {
      _results = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    final allProducts = await _service.getProducts();

    _results = allProducts.where((product) {
      return product.productName
          .toLowerCase()
          .contains(value.toLowerCase());
    }).toList();

    _isSearching = false;
    notifyListeners();
  }

  void clear() {
    _query = "";
    _results = [];
    _isSearching = false;
    notifyListeners();
  }
}