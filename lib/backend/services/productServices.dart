import 'package:mongo_dart/mongo_dart.dart';

import '../database/mongo_service.dart';
import '../models/client/productModel.dart';

class ProductServices {
  // =========================
  // Get All Products
  // =========================

  static Future<List<ProductModel>> getProducts() async {
    final data = await MongoService.products.find().toList();

    return data
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  // =========================
  // Get Products By Category
  // =========================

  static Future<List<ProductModel>> getProductsByCategory(
      ObjectId categoryId) async {
    final data = await MongoService.products
        .find(
          where.eq("categoryId", categoryId),
        )
        .toList();

    return data
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  // =========================
  // Get Product By ID
  // =========================

  static Future<ProductModel?> getProductById(
      ObjectId id) async {
    final data = await MongoService.products.findOne(
      where.id(id),
    );

    if (data == null) return null;

    return ProductModel.fromJson(data);
  }

  // =========================
  // Search Products
  // =========================

  static Future<List<ProductModel>> searchProducts(
      String keyword) async {
    final products = await getProducts();

    return products.where((product) {
      return product.name
              .toLowerCase()
              .contains(keyword.toLowerCase()) ||
          product.brand
              .toLowerCase()
              .contains(keyword.toLowerCase());
    }).toList();
  }

  // =========================
  // Add Product
  // =========================

  static Future<void> addProduct(
      ProductModel product) async {
    await MongoService.products.insertOne(
      product.toJson(),
    );
  }

  // =========================
  // Update Product
  // =========================

  static Future<void> updateProduct(
      ProductModel product) async {
    await MongoService.products.replaceOne(
      where.id(product.id!),
      product.toJson(),
    );
  }

  // =========================
  // Delete Product
  // =========================

  static Future<void> deleteProduct(
      ObjectId id) async {
    await MongoService.products.deleteOne(
      where.id(id),
    );
  }
}