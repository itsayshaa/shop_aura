import 'package:flutter/material.dart';

import '/backend/models/client/categoryModel.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
final CategoryService _service = CategoryService();

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

   _featuredCategories = List.from(_categories);

    _popularBrands = [];

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
  return category.categoriesName
      .toLowerCase()
      .contains(_searchText.toLowerCase());
}).toList();
    }

    notifyListeners();
  }

Future<void> refresh() async {
  _isRefreshing = true;
  notifyListeners();

  try {
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
    return  List.from(_categories);
  }

  void sortAZ() {
    _categories.sort(
      (a, b) => a.categoriesName.compareTo(b.categoriesName)
    );

    _searchResults.sort(
      (a, b) =>a.categoriesName.compareTo(b.categoriesName)
    );

    notifyListeners();
  }

  void sortZA() {
    _categories.sort(
      (a, b) => b.categoriesName.compareTo(a.categoriesName)
    );

    _searchResults.sort(
      (a, b) => b.categoriesName.compareTo(a.categoriesName),
    );

    notifyListeners();
  }

  // void sortProductCount() {
  //   _categories.sort(
  //     (a, b) =>
  //         b.productCount.compareTo(a.productCount),
  //   );

  //   _searchResults.sort(
  //     (a, b) =>
  //         b.productCount.compareTo(a.productCount),
  //   );

  //   notifyListeners();
  // }
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