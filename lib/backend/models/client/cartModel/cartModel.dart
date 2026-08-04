import 'package:mongo_dart/mongo_dart.dart';
import 'cartItem.dart';
class CartModel {
  String? id;
  List<CartItemModel> products;

  double subtotal;
  double discount;
  double couponDiscount;
  double offerDiscount;
  double shipping;
  double tax;
  double finalTotal;

  CartModel({
    this.id,
    required this.products,
    required this.subtotal,
    required this.discount,
    required this.couponDiscount,
    required this.offerDiscount,
    required this.shipping,
    required this.tax,
    required this.finalTotal,
  });

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "products": products.map((e) => e.toJson()).toList(),
      "subtotal": subtotal,
      "discount": discount,
      "couponDiscount": couponDiscount,
      "offerDiscount": offerDiscount,
      "shipping": shipping,
      "tax": tax,
      "finalTotal": finalTotal,
    };
  }
 factory CartModel.fromJson(Map<String, dynamic> json) {
  return CartModel(
    id: json["_id"]?.toString(),

    products: json["products"] == null
        ? []
        : (json["products"] as List)
            .map((e) => CartItemModel.fromJson(e))
            .toList(),

    subtotal: (json["subtotal"] ?? 0).toDouble(),

    discount: (json["discount"] ?? 0).toDouble(),

    couponDiscount: (json["couponDiscount"] ?? 0).toDouble(),

    offerDiscount: (json["offerDiscount"] ?? 0).toDouble(),

    shipping: (json["shipping"] ?? 0).toDouble(),

    tax: (json["tax"] ?? 0).toDouble(),

    finalTotal: (json["finalTotal"] ?? json["subtotal"] ?? 0).toDouble(),
  );
}
}