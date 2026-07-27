import 'package:flutter/foundation.dart';

import 'package:shop_aura/frontend/models/product_model.dart';
import 'package:shop_aura/frontend/services/product_service.dart';

class SearchProvider extends ChangeNotifier {
  final ProductService _service = ProductService.instance;

  List<ProductModel> _results = [];

  bool _isSearching = false;

  String _query = "";

  List<ProductModel> get results => _results;

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

    _results = await _service.searchProducts(value);

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