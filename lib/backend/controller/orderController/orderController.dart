import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shop_aura/backend/models/client/orderModel.dart';
import '../../database/mongo_service.dart';


Future<Response> getOrders(Request request)async{
  final orders = await MongoService.orders.find().toList();
  return Response.ok(
    jsonEncode(orders),
    headers: {"Content-Type":"application/json"}
  );
}

Future<Response> placeOrder(Request request)async{
  try{
  final body = await request.readAsString();
  final data = jsonDecode(body);
  final userId = ObjectId.fromHexString(data["userid"]);
  final items = data["products"];

  double subtotal = 0;
  List<OrderItemModel> orderItem = [];
  for(var item in items){
    final product = await MongoService.products.findOne(
      where.id(ObjectId.fromHexString(item["productId"]))
    );
    if(product == null){
      return Response.notFound("Product Not Found");
    }
    int stock = product["stock"];
    if(stock < item["quantity"]){
      return Response(
        400,
        body: jsonEncode({
          "success":false,
          "message":"${product["name"]} is out of stock"
    })
      );
    }

    double price = (product["price"] as num).toDouble();
    int quantity = item["quantity"];
    double itemSubtotal = price * quantity;
    subtotal += itemSubtotal;
    orderItem.add(
  OrderItemModel(
    productId: product["_id"],
    name: product["name"],
    image: product["images"][0]["url"],
    color: item["color"] ?? "",
    size: item["size"] ?? "",
    price: price,
    quantity: quantity,
    subtotal: itemSubtotal,
  ),
);
  } 
  double discount = 0;

if (subtotal >= 5000) {
  discount = subtotal * 0.10;
}
double tax = (subtotal - discount) * 0.18;
double shipping = subtotal >= 1000 ? 0 : 80;
double total = subtotal - discount + tax + shipping;
int orderNumber = DateTime.now().millisecondsSinceEpoch;
final order = OrderModel(
  userId: userId,
  orderNumber: orderNumber,
  products: orderItem,
  paymentMethod: data["paymentMethod"],
  paymentStatus: "Pending",
  orderStatus: "Pending",
  subTotal: subtotal,
  discount: discount,
  tax: tax,
  shipping: shipping,
  totalAmount: total,
  shippingAddress: ShippingAddressModel.fromJson(
    data["shippingAddress"],
  ),
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
await MongoService.orders.insertOne(order.toJson());
for (var item in orderItem) {
  await MongoService.products.updateOne(
    where.id(item.productId),
    modify.inc("stock", -item.quantity),
  );
}
return Response.ok(
  jsonEncode({
    "success": true,
    "message": "Order placed successfully",
    "orderNumber": orderNumber,
  }),
  headers: {
    "Content-Type": "application/json",
  },
);
  }catch (e) {
  return Response.internalServerError(
    body: jsonEncode({
      "success": false,
      "message": e.toString(),
    }),
    headers: {
      "Content-Type": "application/json",
    },
  );
}
}