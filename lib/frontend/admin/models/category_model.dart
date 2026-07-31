class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String? imagePath;
  final String? parentId;
  final String parentName;
  final int productCount;
  final bool isActive;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.imagePath,
    this.parentId,
    this.parentName = '—',
    this.productCount = 0,
    this.isActive = true,
  });

  bool get isParentCategory => parentId == null;

  CategoryModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? imagePath,
    String? parentId,
    String? parentName,
    int? productCount,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      parentId: parentId ?? this.parentId,
      parentName: parentName ?? this.parentName,
      productCount: productCount ?? this.productCount,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'imagePath': imagePath,
      'parentId': parentId,
      'parentName': parentName,
      'productCount': productCount,
      'isActive': isActive,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      slug: map['slug']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      imagePath: map['imagePath']?.toString(),
      parentId: map['parentId']?.toString(),
      parentName: map['parentName']?.toString() ?? '—',
      productCount: _toInt(map['productCount']),
      isActive: map['isActive'] ?? true,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}