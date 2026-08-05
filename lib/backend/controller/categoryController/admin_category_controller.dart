import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../services/admin_category_service.dart';

const Map<String, String> _jsonHeaders = {
  'Content-Type': 'application/json',
};

bool _isValidObjectId(String value) {
  return ObjectId.tryParse(value) != null;
}

Map<String, dynamic> _categoryResponse(
  Map<String, dynamic> category,
) {
  final response = Map<String, dynamic>.from(category);

  if (response['_id'] is ObjectId) {
    response['_id'] =
        (response['_id'] as ObjectId).toHexString();
  }

  if (response['parentId'] is ObjectId) {
    response['parentId'] =
        (response['parentId'] as ObjectId).toHexString();
  }

  return response;
}

// GET: /admin/category/
Future<Response> adminGetAllCategories(
  Request request,
) async {
  try {
    final categories =
        await AdminCategoryService.getAllCategories();

    return Response.ok(
      jsonEncode(
        categories
            .map(_categoryResponse)
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

// GET: /admin/category/<id>
Future<Response> adminGetCategory(
  Request request,
  String id,
) async {
  try {
    if (!_isValidObjectId(id)) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Invalid category ID',
        }),
        headers: _jsonHeaders,
      );
    }

    final category =
        await AdminCategoryService.getCategoryById(
      ObjectId.fromHexString(id),
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

    return Response.ok(
      jsonEncode(
        _categoryResponse(category),
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

// POST: /admin/category/add
Future<Response> adminAddCategory(
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
          'message': 'Category data is required',
        }),
        headers: _jsonHeaders,
      );
    }

    final data =
        jsonDecode(body)
            as Map<String, dynamic>;

    final name =
        data['name']?.toString() ?? '';

    final slug =
        data['slug']?.toString() ?? '';

    if (name.trim().isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Category name is required',
        }),
        headers: _jsonHeaders,
      );
    }

    if (slug.trim().isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Category slug is required',
        }),
        headers: _jsonHeaders,
      );
    }

    ObjectId? parentId;

    final parentIdValue =
        data['parentId']?.toString();

    if (parentIdValue != null &&
        parentIdValue.isNotEmpty) {
      if (!_isValidObjectId(
        parentIdValue,
      )) {
        return Response(
          400,
          body: jsonEncode({
            'success': false,
            'message': 'Invalid parent category ID',
          }),
          headers: _jsonHeaders,
        );
      }

      parentId =
          ObjectId.fromHexString(
        parentIdValue,
      );
    }

    final categoryData =
        <String, dynamic>{
      'name': name.trim(),
      'slug': slug.trim(),
      'description':
          data['description']
                  ?.toString() ??
              '',
      'imagePath':
          data['imagePath']
                  ?.toString() ??
              '',
      'parentId': parentId,
      'parentName':
          data['parentName']
                  ?.toString() ??
              '',
      'productCount':
          (data['productCount'] ?? 0)
              .toInt(),
      'isActive':
          data['isActive'] ?? true,
    };

    final categoryId =
        await AdminCategoryService
            .addCategory(
      categoryData,
    );

    return Response(
      201,
      body: jsonEncode({
        'success': true,
        'message':
            'Category added successfully',
        'categoryId':
            categoryId?.toHexString(),
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

// PUT: /admin/category/<id>
Future<Response> adminUpdateCategory(
  Request request,
  String id,
) async {
  try {
    if (!_isValidObjectId(id)) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Invalid category ID',
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
          'message': 'Category data is required',
        }),
        headers: _jsonHeaders,
      );
    }

    final data =
        jsonDecode(body)
            as Map<String, dynamic>;

    final name =
        data['name']?.toString() ?? '';

    final slug =
        data['slug']?.toString() ?? '';

    if (name.trim().isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Category name is required',
        }),
        headers: _jsonHeaders,
      );
    }

    if (slug.trim().isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Category slug is required',
        }),
        headers: _jsonHeaders,
      );
    }

    ObjectId? parentId;

    final parentIdValue =
        data['parentId']?.toString();

    if (parentIdValue != null &&
        parentIdValue.isNotEmpty) {
      if (!_isValidObjectId(
        parentIdValue,
      )) {
        return Response(
          400,
          body: jsonEncode({
            'success': false,
            'message': 'Invalid parent category ID',
          }),
          headers: _jsonHeaders,
        );
      }

      parentId =
          ObjectId.fromHexString(
        parentIdValue,
      );
    }

    final categoryData =
        <String, dynamic>{
      '_id':
          ObjectId.fromHexString(id),
      'name': name.trim(),
      'slug': slug.trim(),
      'description':
          data['description']
                  ?.toString() ??
              '',
      'imagePath':
          data['imagePath']
                  ?.toString() ??
              '',
      'parentId': parentId,
      'parentName':
          data['parentName']
                  ?.toString() ??
              '',
      'productCount':
          (data['productCount'] ?? 0)
              .toInt(),
      'isActive':
          data['isActive'] ?? true,
    };

    await AdminCategoryService
        .updateCategory(
      ObjectId.fromHexString(id),
      categoryData,
    );

    return Response.ok(
      jsonEncode({
        'success': true,
        'message':
            'Category updated successfully',
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

// DELETE: /admin/category/<id>
Future<Response> adminDeleteCategory(
  Request request,
  String id,
) async {
  try {
    if (!_isValidObjectId(id)) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Invalid category ID',
        }),
        headers: _jsonHeaders,
      );
    }

    await AdminCategoryService
        .deleteCategory(
      ObjectId.fromHexString(id),
    );

    return Response.ok(
      jsonEncode({
        'success': true,
        'message':
            'Category deleted successfully',
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

// PATCH: /admin/category/<id>/status
Future<Response> adminUpdateCategoryStatus(
  Request request,
  String id,
) async {
  try {
    if (!_isValidObjectId(id)) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Invalid category ID',
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
          'message': 'Status data is required',
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

    await AdminCategoryService
        .updateCategoryStatus(
      ObjectId.fromHexString(id),
      data['isActive'] as bool,
    );

    return Response.ok(
      jsonEncode({
        'success': true,
        'message':
            'Category status updated successfully',
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

// GET: /admin/category/search/<keyword>
Future<Response> adminSearchCategories(
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

    final categories =
        await AdminCategoryService
            .searchCategories(
      keyword,
    );

    return Response.ok(
      jsonEncode(
        categories
            .map(_categoryResponse)
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