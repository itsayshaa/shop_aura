import 'package:mongo_dart/mongo_dart.dart';

import '../database/mongo_service.dart';
import '../models/client/categoryModel.dart';

class CategoryServices {
  // =========================
  // Get All Categories
  // =========================

  static Future<List<CategoryModel>> getCategories() async {
    final data = await MongoService.categories.find().toList();

    return data
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }

  // =========================
  // Get Featured Categories
  // =========================

  static Future<List<CategoryModel>> getFeaturedCategories() async {
    final data = await MongoService.categories
        .find(
          where.eq("isFeatured", true),
        )
        .toList();

    return data
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }

  // =========================
  // Search Categories
  // =========================

  static Future<List<CategoryModel>> searchCategory(
      String keyword) async {
    final categories = await getCategories();

    return categories.where((category) {
      return category.name
          .toLowerCase()
          .contains(keyword.toLowerCase());
    }).toList();
  }

  // =========================
  // Add Category
  // =========================

  static Future<void> addCategory(
      CategoryModel category) async {
    await MongoService.categories.insertOne(
      category.toJson(),
    );
  }

  // =========================
  // Update Category
  // =========================

  static Future<void> updateCategory(
      CategoryModel category) async {
    await MongoService.categories.replaceOne(
      where.id(category.id!),
      category.toJson(),
    );
  }

  // =========================
  // Delete Category
  // =========================

  static Future<void> deleteCategory(
      ObjectId id) async {
    await MongoService.categories.deleteOne(
      where.id(id),
    );
  }
}