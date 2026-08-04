import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shop_aura/backend/database/mongo_service.dart';

import '../../models/client/productModel.dart';
import '../../services/admin_product_service.dart';

const Map<String, String> _jsonHeaders = {
  'Content-Type': 'application/json',
};

Map<String, dynamic> _productToResponse(
  ProductsModel product,
) {
  return {
    '_id': product.id?.toHexString(),
    'categoryId': product.categoryId?.toHexString(),
    'name': product.productName,
    'brand': product.brand,
    'description': product.description,
    'images': product.productImage,
    'price': product.price,
    // 'oldPrice': product.oldPrice,
    'rating': product.rating,
    'reviews': product.reviews,
    'stock': product.stock,
    'discount': product.discountPrice,
    // 'isFeatured': product.isFeatured,
    // 'isBestSeller': product.isBestSeller,
    // 'isFlashSale': product.isFlashSale,
    'isActive': product.isActive
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
final category = await MongoService.categories.findOne(
  where.id(ObjectId.fromHexString(categoryId)),
);

if (category == null) {
  return Response(
    404,
    body: jsonEncode({
      'success': false,
      'message': 'Category not found',
    }),
    headers: _jsonHeaders,
  );
}

final categoryName = category['name'];
List<String> colors = [
  "red",
  "blue",
  "green"
]; 
List<String> size = [
  "10",
  "20"
];
    final product = ProductsModel(
  categoryId: ObjectId.fromHexString(categoryId),

  categoryName: categoryName,

  productName: name,

  brand: data['brand']?.toString() ?? '',

  description: data['description']?.toString() ?? '',

  productImage: List<String>.from(
    data['images'] ?? [],
  ),

  color: colors,

  size: size,

  weight: data['weight']?.toString() ?? "",

  status: data['status']?.toString() ?? "Available",

  price: (data['price'] ?? 0).toDouble(),

  rating: (data['rating'] ?? 0).toDouble(),

  reviews: (data['reviews'] ?? 0).toInt(),

  stock: (data['stock'] ?? 0).toInt(),

  discountPrice:
      (data['discount'] ?? 0).toDouble(),

  isActive:
      data['isActive'] ?? true,

  isTrending:
      data['isTrending'] ?? false,

  isDeleted: false,

  createdAt: DateTime.now(),

  updatedAt: DateTime.now(),
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
final category = await MongoService.categories.findOne(
  where.id(ObjectId.fromHexString(categoryId)),
);

if (category == null) {
  return Response(
    404,
    body: jsonEncode({
      'success': false,
      'message': 'Category not found',
    }),
    headers: _jsonHeaders,
  );
}

final categoryName = category['name'];
List<String> colors = [
  "red",
  "blue",
  "green"
]; 
List<String> size = [
  "10",
  "20"
];
final name =
        data['name']?.toString() ?? '';
final product = ProductsModel(
  categoryId: ObjectId.fromHexString(categoryId),

  categoryName: categoryName,

  productName: name,

  brand: data['brand']?.toString() ?? '',

  description: data['description']?.toString() ?? '',

  productImage: List<String>.from(
    data['images'] ?? [],
  ),

  color: colors,

  size: size,

  weight: data['weight']?.toString() ?? "",

  status: data['status']?.toString() ?? "Available",

  price: (data['price'] ?? 0).toDouble(),

  rating: (data['rating'] ?? 0).toDouble(),

  reviews: (data['reviews'] ?? 0).toInt(),

  stock: (data['stock'] ?? 0).toInt(),

  discountPrice:
      (data['discount'] ?? 0).toDouble(),

  isActive:
      data['isActive'] ?? true,

  isTrending:
      data['isTrending'] ?? false,

  isDeleted: false,

  createdAt: DateTime.now(),

  updatedAt: DateTime.now(),
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