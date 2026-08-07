import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../models/client/banner_model.dart';
import '../services/admin_banner_service.dart';

class AdminBannerController {
  // GET: /admin/banner/
  // Get all banners for the Admin Panel
  static Future<Response> getAllBanners(
    Request request,
  ) async {
    try {
      final banners =
          await AdminBannerService.getAllBanners();

      return Response.ok(
        jsonEncode(
          {
            'success': true,
            'message':
                'Banners fetched successfully',
            'data': banners
                .map(
                  (banner) => banner.toJson(),
                )
                .toList(),
          },
        ),
        headers: {
          'Content-Type':
              'application/json',
        },
      );
    } catch (error) {
      return _serverError(error);
    }
  }

  // GET: /admin/banner/<id>
  // Get one banner by ID
  static Future<Response> getBannerById(
    Request request,
    String id,
  ) async {
    try {
      final bannerId =
          ObjectId.parse(id);

      final banner =
          await AdminBannerService
              .getBannerById(
        bannerId,
      );

      if (banner == null) {
        return _notFound(
          'Banner not found',
        );
      }

      return Response.ok(
        jsonEncode(
          {
            'success': true,
            'message':
                'Banner fetched successfully',
            'data': banner.toJson(),
          },
        ),
        headers: {
          'Content-Type':
              'application/json',
        },
      );
    } catch (error) {
      return _badRequest(
        'Invalid banner ID',
      );
    }
  }

  // POST: /admin/banner/
  // Add a new banner
  static Future<Response> addBanner(
    Request request,
  ) async {
    try {
      final body =
          await request.readAsString();

      final json =
          jsonDecode(body);

      if (json is! Map<String, dynamic>) {
        return _badRequest(
          'Invalid request data',
        );
      }

      final title =
          json['title']
                  ?.toString()
                  .trim() ??
              '';

      final imageUrl =
          json['imageUrl']
                  ?.toString()
                  .trim() ??
              '';

      final location =
          json['location']
                  ?.toString()
                  .trim() ??
              '';

      if (title.isEmpty) {
        return _badRequest(
          'Banner title is required',
        );
      }

      if (imageUrl.isEmpty) {
        return _badRequest(
          'Banner image URL is required',
        );
      }

      if (location.isEmpty) {
        return _badRequest(
          'Banner location is required',
        );
      }

      final displayOrder =
          json['displayOrder'] is num
              ? (json['displayOrder']
                      as num)
                  .toInt()
              : int.tryParse(
                    json['displayOrder']
                            ?.toString() ??
                        '',
                  ) ??
                  0;

      final isActive =
          json['isActive'] is bool
              ? json['isActive']
                  as bool
              : true;

      final banner =
          BannerModel(
        title: title,
        imageUrl: imageUrl,
        location: location,
        displayOrder:
            displayOrder,
        isActive:
            isActive,
        createdAt:
            DateTime.now(),
      );

      final bannerId =
          await AdminBannerService
              .addBanner(
        banner,
      );

      return Response(
        201,
        body: jsonEncode(
          {
            'success': true,
            'message':
                'Banner added successfully',
            'data': {
              'id':
                  bannerId
                      ?.toHexString(),
            },
          },
        ),
        headers: {
          'Content-Type':
              'application/json',
        },
      );
    } catch (error) {
      return _serverError(error);
    }
  }

  // PUT: /admin/banner/<id>
  // Update a banner
  static Future<Response> updateBanner(
    Request request,
    String id,
  ) async {
    try {
      final bannerId =
          ObjectId.parse(id);

      final oldBanner =
          await AdminBannerService
              .getBannerById(
        bannerId,
      );

      if (oldBanner == null) {
        return _notFound(
          'Banner not found',
        );
      }

      final body =
          await request.readAsString();

      final json =
          jsonDecode(body);

      if (json is! Map<String, dynamic>) {
        return _badRequest(
          'Invalid request data',
        );
      }

      final title =
          json.containsKey(
                'title',
              )
              ? json['title']
                      ?.toString()
                      .trim() ??
                  ''
              : oldBanner.title;

      final imageUrl =
          json.containsKey(
                'imageUrl',
              )
              ? json['imageUrl']
                      ?.toString()
                      .trim() ??
                  ''
              : oldBanner.imageUrl;

      final location =
          json.containsKey(
                'location',
              )
              ? json['location']
                      ?.toString()
                      .trim() ??
                  ''
              : oldBanner.location;

      final displayOrder =
          json.containsKey(
                'displayOrder',
              )
              ? (json['displayOrder']
                          is num
                      ? (json[
                                  'displayOrder']
                              as num)
                          .toInt()
                      : int.tryParse(
                            json[
                                        'displayOrder']
                                    ?.toString() ??
                                '',
                          ) ??
                          oldBanner
                              .displayOrder)
              : oldBanner
                  .displayOrder;

      final isActive =
          json.containsKey(
                'isActive',
              )
              ? (json['isActive']
                      is bool
                  ? json['isActive']
                      as bool
                  : oldBanner
                      .isActive)
              : oldBanner
                  .isActive;

      if (title.isEmpty) {
        return _badRequest(
          'Banner title cannot be empty',
        );
      }

      if (imageUrl.isEmpty) {
        return _badRequest(
          'Banner image URL cannot be empty',
        );
      }

      if (location.isEmpty) {
        return _badRequest(
          'Banner location cannot be empty',
        );
      }

      final updatedBanner =
          BannerModel(
        id: bannerId,
        title: title,
        imageUrl: imageUrl,
        location: location,
        displayOrder:
            displayOrder,
        isActive:
            isActive,
        createdAt:
            oldBanner.createdAt,
      );

      await AdminBannerService
          .updateBanner(
        updatedBanner,
      );

      return Response.ok(
        jsonEncode(
          {
            'success': true,
            'message':
                'Banner updated successfully',
          },
        ),
        headers: {
          'Content-Type':
              'application/json',
        },
      );
    } on FormatException {
      return _badRequest(
        'Invalid banner ID',
      );
    } catch (error) {
      return _serverError(error);
    }
  }

  // DELETE: /admin/banner/<id>
  // Delete a banner
  static Future<Response> deleteBanner(
    Request request,
    String id,
  ) async {
    try {
      final bannerId =
          ObjectId.parse(id);

      final banner =
          await AdminBannerService
              .getBannerById(
        bannerId,
      );

      if (banner == null) {
        return _notFound(
          'Banner not found',
        );
      }

      await AdminBannerService
          .deleteBanner(
        bannerId,
      );

      return Response.ok(
        jsonEncode(
          {
            'success': true,
            'message':
                'Banner deleted successfully',
          },
        ),
        headers: {
          'Content-Type':
              'application/json',
        },
      );
    } on FormatException {
      return _badRequest(
        'Invalid banner ID',
      );
    } catch (error) {
      return _serverError(error);
    }
  }

  // PATCH: /admin/banner/<id>/status
  // Change banner active/inactive status
  static Future<Response>
      updateBannerStatus(
    Request request,
    String id,
  ) async {
    try {
      final bannerId =
          ObjectId.parse(id);

      final banner =
          await AdminBannerService
              .getBannerById(
        bannerId,
      );

      if (banner == null) {
        return _notFound(
          'Banner not found',
        );
      }

      final body =
          await request.readAsString();

      final json =
          jsonDecode(body);

      if (json is! Map<String, dynamic>) {
        return _badRequest(
          'Invalid request data',
        );
      }

      if (json['isActive']
          is! bool) {
        return _badRequest(
          'isActive must be true or false',
        );
      }

      await AdminBannerService
          .updateBannerStatus(
        bannerId,
        json['isActive']
            as bool,
      );

      return Response.ok(
        jsonEncode(
          {
            'success': true,
            'message':
                'Banner status updated successfully',
          },
        ),
        headers: {
          'Content-Type':
              'application/json',
        },
      );
    } on FormatException {
      return _badRequest(
        'Invalid banner ID',
      );
    } catch (error) {
      return _serverError(error);
    }
  }

  // GET: /admin/banner/location/<location>
  // Get banners by location for the Admin Panel
  static Future<Response>
      getBannersByLocation(
    Request request,
    String location,
  ) async {
    try {
      final banners =
          await AdminBannerService
              .getBannersByLocation(
        location,
      );

      return Response.ok(
        jsonEncode(
          {
            'success': true,
            'message':
                'Location banners fetched successfully',
            'data': banners
                .map(
                  (banner) => banner.toJson(),
                )
                .toList(),
          },
        ),
        headers: {
          'Content-Type':
              'application/json',
        },
      );
    } catch (error) {
      return _serverError(error);
    }
  }

  // GET: /banner/active
  // Get all active banners for the Client App
  static Future<Response>
      getActiveBanners(
    Request request,
  ) async {
    try {
      final banners =
          await AdminBannerService
              .getActiveBanners();

      return Response.ok(
        jsonEncode(
          {
            'success': true,
            'message':
                'Active banners fetched successfully',
            'data': banners
                .map(
                  (banner) => banner.toJson(),
                )
                .toList(),
          },
        ),
        headers: {
          'Content-Type':
              'application/json',
        },
      );
    } catch (error) {
      return _serverError(error);
    }
  }

  // GET: /banner/active/location/<location>
  // Get active banners for a specific client location
  static Future<Response>
      getActiveBannersByLocation(
    Request request,
    String location,
  ) async {
    try {
      final banners =
          await AdminBannerService
              .getActiveBannersByLocation(
        location,
      );

      return Response.ok(
        jsonEncode(
          {
            'success': true,
            'message':
                'Active location banners fetched successfully',
            'data': banners
                .map(
                  (banner) => banner.toJson(),
                )
                .toList(),
          },
        ),
        headers: {
          'Content-Type':
              'application/json',
        },
      );
    } catch (error) {
      return _serverError(error);
    }
  }

  // Common JSON response helpers

  static Response _badRequest(
    String message,
  ) {
    return Response(
      400,
      body: jsonEncode(
        {
          'success': false,
          'message': message,
        },
      ),
      headers: {
        'Content-Type':
            'application/json',
      },
    );
  }

  static Response _notFound(
    String message,
  ) {
    return Response(
      404,
      body: jsonEncode(
        {
          'success': false,
          'message': message,
        },
      ),
      headers: {
        'Content-Type':
            'application/json',
      },
    );
  }

  static Response _serverError(
    Object error,
  ) {
    return Response(
      500,
      body: jsonEncode(
        {
          'success': false,
          'message':
              'Internal server error',
          'error':
              error.toString(),
        },
      ),
      headers: {
        'Content-Type':
            'application/json',
      },
    );
  }
}