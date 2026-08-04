import 'package:mongo_dart/mongo_dart.dart';

import '../database/mongo_service.dart';
import '../models/client/productModel.dart';

class ProductServices {
  static Future<List<ProductsModel>> getProducts() async {
    final data = await MongoService.products.find().toList();

    return data
        .map((e) => ProductsModel.fromJson(e))
        .toList();
  }



  static Future<List<ProductsModel>> getProductsByCategory(
    
      ObjectId categoryId) async {
    final data = await MongoService.products.find().toList();
    return data
        .map((e) => ProductsModel.fromJson(e))
        .toList();
  }



  static Future<ProductsModel?> getProductById(
      ObjectId id) async {
    final data = await MongoService.products.findOne(
      where.id(id),
    );

    if (data == null) return null;

    return ProductsModel.fromJson(data);
  }

  static Future<List<ProductsModel>> searchProducts(
      String keyword) async {
    final products = await getProducts();

    return products.where((product) {
      return product.productName
              .toLowerCase()
              .contains(keyword.toLowerCase()) ||
          product.brand
              .toLowerCase()
              .contains(keyword.toLowerCase());
    }).toList();
  }


  static Future<void> addProduct(
      ProductsModel product) async {
    await MongoService.products.insertOne(
      product.toJson(),
    );
  }


  static Future<void> updateProduct(
      ProductsModel product) async {
    await MongoService.products.replaceOne(
      where.id(product.id!),
      product.toJson(),
    );
  }


  static Future<void> deleteProduct(
      ObjectId id) async {
    await MongoService.products.deleteOne(
      where.id(id),
    );
  }
}