import 'package:mongo_dart/mongo_dart.dart';

class ProductsModel {
  
  ObjectId? id;
  ObjectId? categoryId;

  String productName;
  String brand;
  String description;
  String categoryName;

  List<String> productImage;
  String weight;
  List<String> size;
  List<String> color;
  String status;

  double price;

  double rating;
  int reviews;

  int stock;
  double discountPrice;

  DateTime createdAt;
  DateTime updatedAt;

  bool isTrending;
  bool isDeleted;
  bool isActive;
  ProductsModel({
    this.id,
    this.categoryId,
    required this.isActive,
    required this.productName,
    required this.categoryName,
    required this.brand,
    required this.description,
    required this.productImage,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.stock,
    required this.discountPrice,
    this.isTrending = false,
    this.isDeleted = false,
    required this.color,
    required this.createdAt,
    required this.size,
    required this.status,
    required this.updatedAt,
    required this.weight,
  });

factory ProductsModel.fromJson(Map<String, dynamic> json) {
  return ProductsModel(
    id: json["_id"] != null
    ? ObjectId.fromHexString(json["_id"])
    : null,
    categoryId: null,
    isActive: true,
    categoryName: json["category"] ?? "",
    productName: json["name"] ?? "",
    brand: json["brand"] ?? "",
    description: json["description"] ?? "",
    productImage: (json["images"] as List? ?? [])
        .map((e) => e["url"].toString())
        .toList(),
    price: (json["price"] as num?)?.toDouble() ?? 0,
    rating: (json["rating"] as num?)?.toDouble() ?? 0,
    reviews: json["reviews"] ?? 0,
    stock: json["stock"] ?? 0,
    discountPrice: (json["discountPrice"] as num?)?.toDouble() ?? 0,
    isTrending: json["isTrending"] ?? false,
    isDeleted: json["isDeleted"] ?? false,
    color: List<String>.from(json["color"] ?? []),
    size: List<String>.from(json["size"] ?? []),
    status: json["status"] ?? "",
    weight: json["weight"] ?? "",
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] != null
        ? DateTime.parse(json["updatedAt"])
        : DateTime.now(),
  );
}

Map<String, dynamic> toJson() {
  return {
    "id": id?.toHexString(),
    "categoryId": categoryId?.toHexString(),
    "categoryName": categoryName,
    "productName": productName,
    "brand": brand,
    "description": description,
    "productImage": productImage,
    "price": price,
    "rating": rating,
    "reviews": reviews,
    "stock": stock,
    "discountPrice": discountPrice,
    "isTrending": isTrending,
    "color": color,
    "size": size,
    "status": status,
    "weight": weight,
    "isActive":isActive,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "isDeleted": isDeleted,
  };
}
}
