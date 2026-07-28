import 'package:mongo_dart/mongo_dart.dart';

class CategoryModel {
  ObjectId? id;

  String name;
  String image;
  int productCount;
  bool isFeatured;

  CategoryModel({
    this.id,
    required this.name,
    required this.image,
    required this.productCount,
    this.isFeatured = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["_id"] as ObjectId?,
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      productCount: json["productCount"] ?? 0,
      isFeatured: json["isFeatured"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "image": image,
      "productCount": productCount,
      "isFeatured": isFeatured,
    };
  }
}