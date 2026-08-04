import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_aura/main.dart';
import 'package:shop_aura/backend/models/client/productModel.dart';

class ProductService {
  Future<List<ProductsModel>> getProducts() async {
    final response = await http.get(
      Uri.parse("${Apiconfig.baseUrl}/product/"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((e) => ProductsModel.fromJson(e))
          .toList();
    }

    throw Exception("Failed to load products");
  }

Future<List<ProductsModel>> searchProducts(String query) async {
  final response = await http.get(
    Uri.parse("${Apiconfig.baseUrl}/product/search/$query"),
    headers: {
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data
        .map((e) => ProductsModel.fromJson(e))
        .toList();
  }

  return [];
}
Future<List<ProductsModel>> getProductsByCategory(String categoryId) async {
  final products = await getProducts();

  return products.where((product) {
    return product.categoryId?.toHexString() == categoryId;
  }).toList();
}

Future<ProductsModel?> getProduct(String id) async {
  final products = await getProducts();

  try {
    return products.firstWhere((product) => product.id == id);
  } catch (_) {
    return null;
  }
}
}