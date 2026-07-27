import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService.instance;

  List<ProductModel> _products = [];
  List<ProductModel> _searchResults = [];

  bool _isLoading = false;
  String _error = '';

  List<ProductModel> get products =>
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

  Future<List<ProductModel>> getProductsByCategory(
      String category) async {
    return await _service.getProductsByCategory(category);
  }

  Future<ProductModel?> getProductById(String id) async {
    return await _service.getProduct(id);
  }

  void clear() {
    _products.clear();
    _searchResults.clear();
    notifyListeners();
  }
}