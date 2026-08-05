import 'package:shelf_router/shelf_router.dart';

import '../../controller/admin_banner_controller.dart';

final Router adminBannerRouter = Router()

  // Admin: Get all banners
  ..get(
    '/',
    AdminBannerController.getAllBanners,
  )

  // Admin: Add a new banner
  ..post(
    '/',
    AdminBannerController.addBanner,
  )

  // Admin: Get banners by location
  // Keep this route before /<id>
  ..get(
    '/location/<location>',
    AdminBannerController.getBannersByLocation,
  )

  // Admin: Get one banner by ID
  ..get(
    '/<id>',
    AdminBannerController.getBannerById,
  )

  // Admin: Update a banner
  ..put(
    '/<id>',
    AdminBannerController.updateBanner,
  )

  // Admin: Delete a banner
  ..delete(
    '/<id>',
    AdminBannerController.deleteBanner,
  )

  // Admin: Change active/inactive status
  ..patch(
    '/<id>/status',
    AdminBannerController.updateBannerStatus,
  );