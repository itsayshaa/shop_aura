import 'package:mongo_dart/mongo_dart.dart';

class CartItemModel {
  ObjectId productId;
  String name;
  String image;
  String color;
  String size;
  double price;
  double originalPrice;
  int quantity;
  int stock;
  double subtotal;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.color,
    required this.size,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    required this.stock,
    required this.subtotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json["productId"] is ObjectId
          ? json["productId"]
          : ObjectId.fromHexString(json["productId"]),

      name: json["name"] ?? "",
      image: json["image"] ?? "",
      color: json["color"] ?? "",
      size: json["size"] ?? "",
      price: (json["price"] ?? 0).toDouble(),
      originalPrice: (json["originalPrice"] ?? 0).toDouble(),
      quantity: json["quantity"] ?? 1,
      stock: json["stock"] ?? 0,
      subtotal: (json["subtotal"] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "name": name,
      "image": image,
      "color": color,
      "size": size,
      "price": price,
      "originalPrice": originalPrice,
      "quantity": quantity,
      "stock": stock,
      "subtotal": subtotal,
    };
  }
}