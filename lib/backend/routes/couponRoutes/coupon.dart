import 'package:shelf_router/shelf_router.dart';
import 'package:shop_aura/backend/controller/couponController/couponController.dart';


class CouponRoutes {
  Router get router{
    final router = Router();
    router.get('/',getCoupons);
    router.post('/create',createcoupon);
    router.delete('/delete',deleteCoupon);
    router.put("/status", changeCouponStatus);
    router.put("/update", updateCoupon);
    return router;
  }
}