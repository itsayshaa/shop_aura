
import 'package:shelf_router/shelf_router.dart';
import '../../controller/orderController/orderController.dart';

class Ordersroute {
  Router get router{
    final router = Router();
    router.get('/',getOrders);
    
    return router;
  }
}