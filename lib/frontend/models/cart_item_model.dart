// import 'package:mongo_dart/mongo_dart.dart';

// class CartItemModel {
//   ObjectId productId;
//   String name;
//   String image;
//   String color;
//   String size;
//   double price;
//   double originalPrice;
//   int quantity;
//   int stock;
//   double subtotal;

//   CartItemModel({
//     required this.productId,
//     required this.name,
//     required this.image,
//     required this.color,
//     required this.size,
//     required this.price,
//     required this.oldPrice,
//     required this.quantity,
//   });

//   Map<String, dynamic> toJson() => {
//         'image': image,
//         'category': category,
//         'name': name,
//         'price': price,
//         'oldPrice': oldPrice,
//         'quantity': quantity,
//       };

//   factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
//         image: json['image'] as String,
//         category: json['category'] as String,
//         name: json['name'] as String,
//         price: json['price'] as int,
//         oldPrice: json['oldPrice'] as int,
//         quantity: json['quantity'] as int,
//       );
// }