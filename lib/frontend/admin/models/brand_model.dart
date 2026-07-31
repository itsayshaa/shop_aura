class BrandModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String? logoPath;
  final bool isActive;

  const BrandModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.logoPath,
    this.isActive = true,
  });

  BrandModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? logoPath,
    bool? isActive,
  }) {
    return BrandModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      logoPath: logoPath ?? this.logoPath,
      isActive: isActive ?? this.isActive,
    );
  }
}