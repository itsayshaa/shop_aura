import 'package:shelf_router/shelf_router.dart';
import 'package:shop_aura/backend/controller/cartController/cartController.dart';
class Cartroutes{
  Router get router{
    final router = Router();
    router.post("/add", addToCart);
    router.get("/<userId>",getCarts);
    router.get("/",getAll);
    router.put("/increase",increaseQuantity);
    router.put("/decrease", decreaseQuantity);
    router.delete("/remove", removeItem);
    return router;
  }}