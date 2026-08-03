import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../models/client/productModel.dart';
import '../../services/admin_product_service.dart';

const Map<String, String> _jsonHeaders = {
  'Content-Type': 'application/json',
};

Map<String, dynamic> _productToResponse(
  ProductModel product,
) {
  return {
    '_id': product.id?.toHexString(),
    'categoryId': product.categoryId?.toHexString(),
    'name': product.name,
    'brand': product.brand,
    'description': product.description,
    'images': product.images,
    'price': product.price,
    'oldPrice': product.oldPrice,
    'rating': product.rating,
    'reviews': product.reviews,
    'stock': product.stock,
    'discount': product.discount,
    'isFeatured': product.isFeatured,
    'isBestSeller': product.isBestSeller,
    'isFlashSale': product.isFlashSale,
    'isActive': product.isActive,
  };
}

Future<Response> adminGetProducts(
  Request request,
) async {
  try {
    final products =
    await AdminProductService.getAllProducts();

    return Response.ok(
      jsonEncode(
        products
            .map(
              (product) =>
                  _productToResponse(product),
            )
            .toList(),
      ),
      headers: _jsonHeaders,
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        'success': false,
        'message': e.toString(),
      }),
      headers: _jsonHeaders,
    );
  }
}

Future<Response> adminGetProduct(
  Request request,
  String id,
) async {
  try {
    if (id.trim().isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Product ID is required',
        }),
        headers: _jsonHeaders,
      );
    }

    if (ObjectId.tryParse(id) == null) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Invalid product ID',
        }),
        headers: _jsonHeaders,
      );
    }

    final product =
        await AdminProductService.getProductById(
      ObjectId.fromHexString(id),
    );

    if (product == null) {
      return Response(
        404,
        body: jsonEncode({
          'success': false,
          'message': 'Product not found',
        }),
        headers: _jsonHeaders,
      );
    }

    return Response.ok(
      jsonEncode(
        _productToResponse(product),
      ),
      headers: _jsonHeaders,
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        'success': false,
        'message': e.toString(),
      }),
      headers: _jsonHeaders,
    );
  }
}

Future<Response> adminAddProduct(
  Request request,
) async {
  try {
    final body =
        await request.readAsString();

    if (body.trim().isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Product data is required',
        }),
        headers: _jsonHeaders,
      );
    }

    final data =
        jsonDecode(body)
            as Map<String, dynamic>;

    final categoryId =
        data['categoryId']?.toString();

    if (categoryId == null ||
        categoryId.isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message':
              'Category ID is required',
        }),
        headers: _jsonHeaders,
      );
    }

   if (ObjectId.tryParse(categoryId) == null) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message':
              'Invalid category ID',
        }),
        headers: _jsonHeaders,
      );
    }

    final name =
        data['name']?.toString() ?? '';

    if (name.trim().isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message':
              'Product name is required',
        }),
        headers: _jsonHeaders,
      );
    }

    final product = ProductModel(
      categoryId:
          ObjectId.fromHexString(
        categoryId,
      ),
      name: name,
      brand:
          data['brand']?.toString() ?? '',
      description:
          data['description']
                  ?.toString() ??
              '',
      images: List<String>.from(
        data['images'] ?? [],
      ),
      price:
          (data['price'] ?? 0)
              .toDouble(),
      oldPrice:
          (data['oldPrice'] ?? 0)
              .toDouble(),
      rating:
          (data['rating'] ?? 0)
              .toDouble(),
      reviews:
          (data['reviews'] ?? 0)
              .toInt(),
      stock:
          (data['stock'] ?? 0)
              .toInt(),
      discount:
          (data['discount'] ?? 0)
              .toInt(),
      isFeatured:
          data['isFeatured'] ?? false,
      isBestSeller:
          data['isBestSeller'] ?? false,
      isFlashSale:
          data['isFlashSale'] ?? false,
      isActive:
          data['isActive'] ?? true,
    );

    await AdminProductService
        .addProduct(product);

    return Response(
      201,
      body: jsonEncode({
        'success': true,
        'message':
            'Product added successfully',
      }),
      headers: _jsonHeaders,
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        'success': false,
        'message': e.toString(),
      }),
      headers: _jsonHeaders,
    );
  }
}

Future<Response> adminUpdateProduct(
  Request request,
  String id,
) async {
  try {
    if (ObjectId.tryParse(id) == null) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Invalid product ID',
        }),
        headers: _jsonHeaders,
      );
    }

    final body =
        await request.readAsString();

    if (body.trim().isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message':
              'Product data is required',
        }),
        headers: _jsonHeaders,
      );
    }

    final data =
        jsonDecode(body)
            as Map<String, dynamic>;

    final categoryId =
        data['categoryId']?.toString();

   if (categoryId == null ||
    ObjectId.tryParse(categoryId) == null) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message':
              'Valid category ID is required',
        }),
        headers: _jsonHeaders,
      );
    }

    final product = ProductModel(
      id: ObjectId.fromHexString(id),
      categoryId:
          ObjectId.fromHexString(
        categoryId,
      ),
      name:
          data['name']?.toString() ?? '',
      brand:
          data['brand']?.toString() ?? '',
      description:
          data['description']
                  ?.toString() ??
              '',
      images: List<String>.from(
        data['images'] ?? [],
      ),
      price:
          (data['price'] ?? 0)
              .toDouble(),
      oldPrice:
          (data['oldPrice'] ?? 0)
              .toDouble(),
      rating:
          (data['rating'] ?? 0)
              .toDouble(),
      reviews:
          (data['reviews'] ?? 0)
              .toInt(),
      stock:
          (data['stock'] ?? 0)
              .toInt(),
      discount:
          (data['discount'] ?? 0)
              .toInt(),
      isFeatured:
          data['isFeatured'] ?? false,
      isBestSeller:
          data['isBestSeller'] ?? false,
      isFlashSale:
          data['isFlashSale'] ?? false,
      isActive:
          data['isActive'] ?? true,
    );

    await AdminProductService
        .updateProduct(product);

    return Response.ok(
      jsonEncode({
        'success': true,
        'message':
            'Product updated successfully',
      }),
      headers: _jsonHeaders,
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        'success': false,
        'message': e.toString(),
      }),
      headers: _jsonHeaders,
    );
  }
}

Future<Response> adminDeleteProduct(
  Request request,
  String id,
) async {
  try {
   if (ObjectId.tryParse(id) == null) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Invalid product ID',
        }),
        headers: _jsonHeaders,
      );
    }

    await AdminProductService
        .deleteProduct(
      ObjectId.fromHexString(id),
    );

    return Response.ok(
      jsonEncode({
        'success': true,
        'message':
            'Product deleted successfully',
      }),
      headers: _jsonHeaders,
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        'success': false,
        'message': e.toString(),
      }),
      headers: _jsonHeaders,
    );
  }
}

Future<Response> adminUpdateProductStatus(
  Request request,
  String id,
) async {
  try {
    if (ObjectId.tryParse(id) == null) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Invalid product ID',
        }),
        headers: _jsonHeaders,
      );
    }

    final body =
        await request.readAsString();

    if (body.trim().isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message':
              'Status data is required',
        }),
        headers: _jsonHeaders,
      );
    }

    final data =
        jsonDecode(body)
            as Map<String, dynamic>;

    if (data['isActive'] is! bool) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message':
              'isActive must be true or false',
        }),
        headers: _jsonHeaders,
      );
    }

    await AdminProductService
        .updateProductStatus(
      ObjectId.fromHexString(id),
      data['isActive'] as bool,
    );

    return Response.ok(
      jsonEncode({
        'success': true,
        'message':
            'Product status updated successfully',
      }),
      headers: _jsonHeaders,
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        'success': false,
        'message': e.toString(),
      }),
      headers: _jsonHeaders,
    );
  }
}

Future<Response> adminSearchProducts(
  Request request,
  String keyword,
) async {
  try {
    if (keyword.trim().isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message':
              'Search keyword is required',
        }),
        headers: _jsonHeaders,
      );
    }

    final products =
        await AdminProductService
            .searchProducts(
      keyword,
    );

    return Response.ok(
      jsonEncode(
        products
            .map(
              (product) =>
                  _productToResponse(product),
            )
            .toList(),
      ),
      headers: _jsonHeaders,
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        'success': false,
        'message': e.toString(),
      }),
      headers: _jsonHeaders,
    );
  }
}