import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../services/admin_brand_service.dart';

const Map<String, String> _jsonHeaders = {
  'Content-Type': 'application/json',
};

bool _isValidObjectId(String value) {
  return ObjectId.tryParse(value) != null;
}

Map<String, dynamic> _brandResponse(
  Map<String, dynamic> brand,
) {
  final response = Map<String, dynamic>.from(brand);

  if (response['_id'] is ObjectId) {
    response['_id'] =
        (response['_id'] as ObjectId).toHexString();
  }

  return response;
}

// GET: /admin/brand/
Future<Response> adminGetAllBrands(
  Request request,
) async {
  try {
    final brands =
        await AdminBrandService.getAllBrands();

    return Response.ok(
      jsonEncode(
        brands
            .map(_brandResponse)
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

// GET: /admin/brand/<id>
Future<Response> adminGetBrand(
  Request request,
  String id,
) async {
  try {
    if (!_isValidObjectId(id)) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Invalid brand ID',
        }),
        headers: _jsonHeaders,
      );
    }

    final brand =
        await AdminBrandService.getBrandById(
      ObjectId.fromHexString(id),
    );

    if (brand == null) {
      return Response(
        404,
        body: jsonEncode({
          'success': false,
          'message': 'Brand not found',
        }),
        headers: _jsonHeaders,
      );
    }

    return Response.ok(
      jsonEncode(
        _brandResponse(brand),
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

// POST: /admin/brand/add
Future<Response> adminAddBrand(
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
          'message': 'Brand data is required',
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
          'message': 'Brand name is required',
        }),
        headers: _jsonHeaders,
      );
    }

    if (slug.trim().isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Brand slug is required',
        }),
        headers: _jsonHeaders,
      );
    }

    final brandData =
        <String, dynamic>{
      'name': name.trim(),
      'slug': slug.trim(),
      'description':
          data['description']
                  ?.toString() ??
              '',
      'logoPath':
          data['logoPath']
                  ?.toString() ??
              '',
      'isActive':
          data['isActive'] ?? true,
    };

    final brandId =
        await AdminBrandService.addBrand(
      brandData,
    );

    return Response(
      201,
      body: jsonEncode({
        'success': true,
        'message':
            'Brand added successfully',
        'brandId':
            brandId?.toHexString(),
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

// PUT: /admin/brand/<id>
Future<Response> adminUpdateBrand(
  Request request,
  String id,
) async {
  try {
    if (!_isValidObjectId(id)) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Invalid brand ID',
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
          'message': 'Brand data is required',
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
          'message': 'Brand name is required',
        }),
        headers: _jsonHeaders,
      );
    }

    if (slug.trim().isEmpty) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Brand slug is required',
        }),
        headers: _jsonHeaders,
      );
    }

    final brandData =
        <String, dynamic>{
      '_id':
          ObjectId.fromHexString(id),
      'name': name.trim(),
      'slug': slug.trim(),
      'description':
          data['description']
                  ?.toString() ??
              '',
      'logoPath':
          data['logoPath']
                  ?.toString() ??
              '',
      'isActive':
          data['isActive'] ?? true,
    };

    await AdminBrandService.updateBrand(
      ObjectId.fromHexString(id),
      brandData,
    );

    return Response.ok(
      jsonEncode({
        'success': true,
        'message':
            'Brand updated successfully',
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

// DELETE: /admin/brand/<id>
Future<Response> adminDeleteBrand(
  Request request,
  String id,
) async {
  try {
    if (!_isValidObjectId(id)) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Invalid brand ID',
        }),
        headers: _jsonHeaders,
      );
    }

    await AdminBrandService.deleteBrand(
      ObjectId.fromHexString(id),
    );

    return Response.ok(
      jsonEncode({
        'success': true,
        'message':
            'Brand deleted successfully',
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

// PATCH: /admin/brand/<id>/status
Future<Response> adminUpdateBrandStatus(
  Request request,
  String id,
) async {
  try {
    if (!_isValidObjectId(id)) {
      return Response(
        400,
        body: jsonEncode({
          'success': false,
          'message': 'Invalid brand ID',
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

    await AdminBrandService
        .updateBrandStatus(
      ObjectId.fromHexString(id),
      data['isActive'] as bool,
    );

    return Response.ok(
      jsonEncode({
        'success': true,
        'message':
            'Brand status updated successfully',
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

// GET: /admin/brand/search/<keyword>
Future<Response> adminSearchBrands(
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

    final brands =
        await AdminBrandService.searchBrands(
      keyword,
    );

    return Response.ok(
      jsonEncode(
        brands
            .map(_brandResponse)
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