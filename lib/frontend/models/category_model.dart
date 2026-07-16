class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final String bannerImage;
  final bool isActive;
  final int productCount;
  final int sortOrder;
  final DateTime? createdAt;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.bannerImage,
    required this.isActive,
    required this.productCount,
    required this.sortOrder,
    this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      bannerImage: json['bannerImage'] ?? '',
      isActive: json['isActive'] ?? true,
      productCount: json['productCount'] ?? 0,
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "description": description,
      "image": image,
      "bannerImage": bannerImage,
      "isActive": isActive,
      "productCount": productCount,
      "sortOrder": sortOrder,
      "createdAt": createdAt?.toIso8601String(),
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    String? bannerImage,
    bool? isActive,
    int? productCount,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      bannerImage: bannerImage ?? this.bannerImage,
      isActive: isActive ?? this.isActive,
      productCount: productCount ?? this.productCount,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'CategoryModel('
        'id: $id, '
        'name: $name, '
        'description: $description, '
        'image: $image, '
        'bannerImage: $bannerImage, '
        'isActive: $isActive, '
        'productCount: $productCount, '
        'sortOrder: $sortOrder'
        ')';
  }
}