import 'package:mongo_dart/mongo_dart.dart';

import '../database/mongo_service.dart';
import '../models/client/productModel.dart';

class AdminProductService {
  // Get all products for the Admin Panel
  static Future<List<ProductModel>> getAllProducts() async {
    final data = await MongoService.products.find().toList();

    return data
        .map(
          (product) => ProductModel.fromJson(product),
        )
        .toList();
  }

  // Get one product by ID
  static Future<ProductModel?> getProductById(
    ObjectId id,
  ) async {
    final data = await MongoService.products.findOne(
      where.id(id),
    );

    if (data == null) {
      return null;
    }

    return ProductModel.fromJson(data);
  }

  // Add a new product
  static Future<ObjectId?> addProduct(
    ProductModel product,
  ) async {
    final result = await MongoService.products.insertOne(
      product.toJson(),
    );

    return result.id;
  }

  // Update an existing product
  static Future<void> updateProduct(
    ProductModel product,
  ) async {
    if (product.id == null) {
      throw Exception(
        'Product ID is required for updating',
      );
    }

    await MongoService.products.replaceOne(
      where.id(product.id!),
      product.toJson(),
    );
  }

  // Delete a product
  static Future<void> deleteProduct(
    ObjectId id,
  ) async {
    await MongoService.products.deleteOne(
      where.id(id),
    );
  }

  // Change product active/inactive status
  static Future<void> updateProductStatus(
    ObjectId id,
    bool isActive,
  ) async {
    await MongoService.products.updateOne(
      where.id(id),
      modify.set(
        'isActive',
        isActive,
      ),
    );
  }

  // Search products by name or brand
  static Future<List<ProductModel>> searchProducts(
    String keyword,
  ) async {
    final products = await getAllProducts();

    final searchText = keyword
        .trim()
        .toLowerCase();

    if (searchText.isEmpty) {
      return products;
    }

    return products.where(
      (product) {
        return product.name
                .toLowerCase()
                .contains(searchText) ||
            product.brand
                .toLowerCase()
                .contains(searchText);
      },
    ).toList();
  }
}