import 'package:mongo_dart/mongo_dart.dart';

class ProductModel {
  ObjectId? id;
  ObjectId? categoryId;

  String name;
  String brand;
  String description;

  List<String> images;

  double price;
  double oldPrice;

  double rating;
  int reviews;

  int stock;
  int discount;

  bool isFeatured;
  bool isBestSeller;
  bool isFlashSale;
  bool isActive;

  ProductModel({
    this.id,
    this.categoryId,
    required this.name,
    required this.brand,
    required this.description,
    required this.images,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.stock,
    required this.discount,
    this.isFeatured = false,
    this.isBestSeller = false,
    this.isFlashSale = false,
    this.isActive = true,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["_id"] as ObjectId?,
      categoryId: json["categoryId"] as ObjectId?,
      name: json["name"] ?? "",
      brand: json["brand"] ?? "",
      description: json["description"] ?? "",
      images: List<String>.from(json["images"] ?? []),
      price: (json["price"] ?? 0).toDouble(),
      oldPrice: (json["oldPrice"] ?? 0).toDouble(),
      rating: (json["rating"] ?? 0).toDouble(),
      reviews: json["reviews"] ?? 0,
      stock: json["stock"] ?? 0,
      discount: json["discount"] ?? 0,
      isFeatured: json["isFeatured"] ?? false,
      isBestSeller: json["isBestSeller"] ?? false,
      isFlashSale: json["isFlashSale"] ?? false,
      isActive: json["isActive"] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "categoryId": categoryId,
      "name": name,
      "brand": brand,
      "description": description,
      "images": images,
      "price": price,
      "oldPrice": oldPrice,
      "rating": rating,
      "reviews": reviews,
      "stock": stock,
      "discount": discount,
      "isFeatured": isFeatured,
      "isBestSeller": isBestSeller,
      "isFlashSale": isFlashSale,
      "isActive": isActive,
    };
  }
}
