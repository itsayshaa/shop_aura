import 'package:mongo_dart/mongo_dart.dart';

import '../database/mongo_service.dart';

class AdminBrandService {
  // Get all brands for the Admin Panel
  static Future<List<Map<String, dynamic>>> getAllBrands() async {
    final data = await MongoService.brands.find().toList();

    return data;
  }

  // Get one brand by ID
  static Future<Map<String, dynamic>?> getBrandById(
    ObjectId id,
  ) async {
    final data = await MongoService.brands.findOne(
      where.id(id),
    );

    return data;
  }

  // Add a new brand
  static Future<ObjectId?> addBrand(
    Map<String, dynamic> brandData,
  ) async {
    final result = await MongoService.brands.insertOne(
      brandData,
    );

    return result.id;
  }

  // Update an existing brand
  static Future<void> updateBrand(
    ObjectId id,
    Map<String, dynamic> brandData,
  ) async {
    await MongoService.brands.replaceOne(
      where.id(id),
      brandData,
    );
  }

  // Delete a brand
  static Future<void> deleteBrand(
    ObjectId id,
  ) async {
    await MongoService.brands.deleteOne(
      where.id(id),
    );
  }

  // Change brand active/inactive status
  static Future<void> updateBrandStatus(
    ObjectId id,
    bool isActive,
  ) async {
    await MongoService.brands.updateOne(
      where.id(id),
      modify.set(
        'isActive',
        isActive,
      ),
    );
  }

  // Search brands by name or slug
  static Future<List<Map<String, dynamic>>> searchBrands(
    String keyword,
  ) async {
    final brands = await getAllBrands();

    final searchText = keyword
        .trim()
        .toLowerCase();

    if (searchText.isEmpty) {
      return brands;
    }

    return brands.where(
      (brand) {
        final name = (brand['name'] ?? '')
            .toString()
            .toLowerCase();

        final slug = (brand['slug'] ?? '')
            .toString()
            .toLowerCase();

        return name.contains(searchText) ||
            slug.contains(searchText);
      },
    ).toList();
  }
}