class CategoryModel {
  String? id;

  String categoriesName;
  List<String> categoriesImage;
  String description;
  String? parentCategories;
  String status;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategoryModel({
    this.id,
    required this.categoriesName,
    required this.categoriesImage,
    required this.description,
    this.parentCategories,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["_id"]?.toString(),

      categoriesName: json["categoryName"] ?? "",

      categoriesImage: json["categoryImage"] != null
          ? List<String>.from(json["categoryImage"])
          : [],

      description: json["description"] ?? "",

      parentCategories: json["parentCategories"]?.toString(),

      status: json["status"] ?? "",

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,

      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "categoryName": categoriesName,
      "categoryImage": categoriesImage,
      "description": description,
      "parentCategories": parentCategories,
      "status": status,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}