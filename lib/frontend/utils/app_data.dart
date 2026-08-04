import 'package:flutter/material.dart';

class AppData {
  AppData._();

  static const List<Map<String, dynamic>> homeCategories = [
    {"title": "All", "icon": Icons.apps},
    {"title": "Fashion", "icon": Icons.checkroom},
    {"title": "Electronics", "icon": Icons.devices},
    {"title": "Mobiles", "icon": Icons.smartphone},
    {"title": "Shoes", "icon": Icons.hiking},
    {"title": "Beauty", "icon": Icons.spa},
    {"title": "Furniture", "icon": Icons.chair},
    {"title": "Sports", "icon": Icons.sports_soccer},
    {"title": "Books", "icon": Icons.menu_book},
    {"title": "Watches", "icon": Icons.watch},
    {"title": "Bags", "icon": Icons.shopping_bag},
  ];

  static const List<String> banners = [
    "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200",
    "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200",
    "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=1200",
  ];

  static const List<Map<String, String>> shopCategories = [
    {
      "title": "Footwear",
      "image":
          "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200",
    },
    {
      "title": "Fashion",
      "image":
          "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=1200",
    },
    {
      "title": "Electronics",
      "image":
          "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=1200",
    },
    {
      "title": "Beauty",
      "image":
          "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=1200",
    },
    {
      "title": "Furniture",
      "image":
          "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=1200",
    },
    {
      "title": "Sports",
      "image":
          "https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=1200",
    },
  ];
}