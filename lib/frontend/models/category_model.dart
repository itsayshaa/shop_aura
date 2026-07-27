class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String icon;
  final String description;
  final int productCount;
  final bool isFeatured;
  final List<String> brands;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.icon,
    required this.description,
    required this.productCount,
    required this.isFeatured,
    required this.brands,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      icon: json['icon'] ?? '',
      description: json['description'] ?? '',
      productCount: json['productCount'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      brands: List<String>.from(json['brands'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'icon': icon,
      'description': description,
      'productCount': productCount,
      'isFeatured': isFeatured,
      'brands': brands,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? image,
    String? icon,
    String? description,
    int? productCount,
    bool? isFeatured,
    List<String>? brands,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      productCount: productCount ?? this.productCount,
      isFeatured: isFeatured ?? this.isFeatured,
      brands: brands ?? this.brands,
    );
  }
}