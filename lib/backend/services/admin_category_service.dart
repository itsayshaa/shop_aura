import 'package:mongo_dart/mongo_dart.dart';

import '../database/mongo_service.dart';

class AdminCategoryService {
  // Get all categories for the Admin Panel
  static Future<List<Map<String, dynamic>>> getAllCategories() async {
    final data = await MongoService.categories.find().toList();

    return data;
  }

  // Get one category by ID
  static Future<Map<String, dynamic>?> getCategoryById(
    ObjectId id,
  ) async {
    final data = await MongoService.categories.findOne(
      where.id(id),
    );

    return data;
  }

  // Add a new category
  static Future<ObjectId?> addCategory(
    Map<String, dynamic> categoryData,
  ) async {
    final result = await MongoService.categories.insertOne(
      categoryData,
    );

    return result.id;
  }

  // Update an existing category
  static Future<void> updateCategory(
    ObjectId id,
    Map<String, dynamic> categoryData,
  ) async {
    await MongoService.categories.replaceOne(
      where.id(id),
      categoryData,
    );
  }

  // Delete a category
  static Future<void> deleteCategory(
    ObjectId id,
  ) async {
    await MongoService.categories.deleteOne(
      where.id(id),
    );
  }

  // Change category active/inactive status
  static Future<void> updateCategoryStatus(
    ObjectId id,
    bool isActive,
  ) async {
    await MongoService.categories.updateOne(
      where.id(id),
      modify.set(
        'isActive',
        isActive,
      ),
    );
  }

  // Search categories by name or slug
  static Future<List<Map<String, dynamic>>> searchCategories(
    String keyword,
  ) async {
    final categories = await getAllCategories();

    final searchText = keyword
        .trim()
        .toLowerCase();

    if (searchText.isEmpty) {
      return categories;
    }

    return categories.where(
      (category) {
        final name =
            (category['name'] ?? '')
                .toString()
                .toLowerCase();

        final slug =
            (category['slug'] ?? '')
                .toString()
                .toLowerCase();

        return name.contains(searchText) ||
            slug.contains(searchText);
      },
    ).toList();
  }
}