import 'package:mongo_dart/mongo_dart.dart';

import '../database/mongo_service.dart';
import '../models/client/banner_model.dart';

class AdminBannerService {
  // Get all banners for the Admin Panel
  static Future<List<BannerModel>> getAllBanners() async {
    final data = await MongoService.banners
        .find(
          where
              .sortBy(
                'displayOrder',
              )
              .sortBy(
                'createdAt',
                descending: true,
              ),
        )
        .toList();

    return data
        .map(
          (banner) => BannerModel.fromJson(banner),
        )
        .toList();
  }

  // Get one banner by MongoDB ID
  static Future<BannerModel?> getBannerById(
    ObjectId id,
  ) async {
    final data = await MongoService.banners.findOne(
      where.id(id),
    );

    if (data == null) {
      return null;
    }

    return BannerModel.fromJson(data);
  }

  // Add a new banner
  static Future<ObjectId?> addBanner(
    BannerModel banner,
  ) async {
    final result = await MongoService.banners.insertOne(
      banner.toJson(),
    );

    return result.id;
  }

  // Update an existing banner
  static Future<void> updateBanner(
    BannerModel banner,
  ) async {
    if (banner.id == null) {
      throw Exception(
        'Banner ID is required for updating',
      );
    }

    await MongoService.banners.replaceOne(
      where.id(banner.id!),
      banner.toJson(),
    );
  }

  // Delete a banner
  static Future<void> deleteBanner(
    ObjectId id,
  ) async {
    await MongoService.banners.deleteOne(
      where.id(id),
    );
  }

  // Change banner active/inactive status
  static Future<void> updateBannerStatus(
    ObjectId id,
    bool isActive,
  ) async {
    await MongoService.banners.updateOne(
      where.id(id),
      modify.set(
        'isActive',
        isActive,
      ),
    );
  }

  // Get banners for one location
  // Example: Home Page or Category Page
  static Future<List<BannerModel>> getBannersByLocation(
    String location,
  ) async {
    final data = await MongoService.banners
        .find(
          where
              .eq(
                'location',
                location,
              )
              .sortBy(
                'displayOrder',
              )
              .sortBy(
                'createdAt',
                descending: true,
              ),
        )
        .toList();

    return data
        .map(
          (banner) => BannerModel.fromJson(banner),
        )
        .toList();
  }

  // Get only active banners for the Client App
  static Future<List<BannerModel>> getActiveBanners() async {
    final data = await MongoService.banners
        .find(
          where
              .eq(
                'isActive',
                true,
              )
              .sortBy(
                'displayOrder',
              )
              .sortBy(
                'createdAt',
                descending: true,
              ),
        )
        .toList();

    return data
        .map(
          (banner) => BannerModel.fromJson(banner),
        )
        .toList();
  }

  // Get active banners for a specific client location
  static Future<List<BannerModel>> getActiveBannersByLocation(
    String location,
  ) async {
    final data = await MongoService.banners
        .find(
          where
              .eq(
                'location',
                location,
              )
              .eq(
                'isActive',
                true,
              )
              .sortBy(
                'displayOrder',
              )
              .sortBy(
                'createdAt',
                descending: true,
              ),
        )
        .toList();

    return data
        .map(
          (banner) => BannerModel.fromJson(banner),
        )
        .toList();
  }
}