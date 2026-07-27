import 'package:flutter/material.dart';

import '/frontend/models/category_model.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _service = CategoryService.instance;

  List<CategoryModel> _categories = [];
  List<CategoryModel> _featuredCategories = [];
  List<CategoryModel> _searchResults = [];
  List<String> _popularBrands = [];

  CategoryModel? _selectedCategory;

  bool _isLoading = false;
  bool _isRefreshing = false;

  String _searchText = '';
  String _error = '';

  List<CategoryModel> get categories => _categories;

  List<CategoryModel> get featuredCategories => _featuredCategories;

  List<CategoryModel> get searchResults =>
      _searchText.isEmpty ? _categories : _searchResults;

  List<String> get popularBrands => _popularBrands;

  CategoryModel? get selectedCategory => _selectedCategory;

  bool get isLoading => _isLoading;

  bool get isRefreshing => _isRefreshing;

  bool get hasError => _error.isNotEmpty;

  String get error => _error;

  String get searchText => _searchText;

  Future<void> loadCategories() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _categories = await _service.getCategories();

      _featuredCategories =
          await _service.getFeaturedCategories();

      _popularBrands =
          await _service.getPopularBrands();

      _searchResults = List.from(_categories);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCategory(String keyword) {
    _searchText = keyword.trim();

    if (_searchText.isEmpty) {
      _searchResults = List.from(_categories);
    } else {
      _searchResults = _categories.where((category) {
        return category.name
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            category.productCount
                .toString()
                .contains(_searchText);
      }).toList();
    }

    notifyListeners();
  }

  Future<void> refresh() async {
    _isRefreshing = true;
    notifyListeners();

    try {
      await _service.refreshCategories();
      await loadCategories();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  void selectCategory(CategoryModel category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearSelectedCategory() {
    _selectedCategory = null;
    notifyListeners();
  }

  void clearSearch() {
    _searchText = '';
    _searchResults = List.from(_categories);
    notifyListeners();
  }

  List<CategoryModel> getFeaturedOnly() {
    return _categories
        .where((category) => category.isFeatured)
        .toList();
  }

  void sortAZ() {
    _categories.sort(
      (a, b) => a.name.compareTo(b.name),
    );

    _searchResults.sort(
      (a, b) => a.name.compareTo(b.name),
    );

    notifyListeners();
  }

  void sortZA() {
    _categories.sort(
      (a, b) => b.name.compareTo(a.name),
    );

    _searchResults.sort(
      (a, b) => b.name.compareTo(a.name),
    );

    notifyListeners();
  }

  void sortProductCount() {
    _categories.sort(
      (a, b) =>
          b.productCount.compareTo(a.productCount),
    );

    _searchResults.sort(
      (a, b) =>
          b.productCount.compareTo(a.productCount),
    );

    notifyListeners();
  }
  void reset() {
    _categories.clear();
    _featuredCategories.clear();
    _popularBrands.clear();
    _searchResults.clear();

    _selectedCategory = null;

    _searchText = '';
    _error = '';

    notifyListeners();
  }
}