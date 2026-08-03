import 'package:flutter/material.dart';

import 'package:shop_aura/backend/models/client/productModel.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<ProductsModel> _products = [];
  List<ProductsModel> _searchResults = [];

  bool _isLoading = false;
  String _error = '';

  List<ProductsModel> get products =>
      _searchResults.isEmpty ? _products : _searchResults;

  bool get isLoading => _isLoading;

  bool get hasError => _error.isNotEmpty;

  String get error => _error;

  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _products = await _service.getProducts();
      _searchResults = [];
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadProducts();
  }

  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
    } else {
      _searchResults =
          await _service.searchProducts(query);
    }

    notifyListeners();
  }

Future<List<ProductsModel>> getProductsByCategory(String category) async {
  return await _service.getProductsByCategory(category);
}

Future<ProductsModel?> getProductById(String id) async {
  return await _service.getProduct(id);
}

  void clear() {
    _products.clear();
    _searchResults.clear();
    notifyListeners();
  }
}