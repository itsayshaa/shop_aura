class AdminBannerModel {
  final String id;

  final String title;

  final String imageUrl;

  // Where the banner will be displayed in the client app.
  // Example: Home Page or Categories Page.
  final String location;

  // Lower numbers appear first.
  final int displayOrder;

  final bool isActive;

  final DateTime createdAt;

  const AdminBannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.displayOrder,
    required this.isActive,
    required this.createdAt,
  });

  AdminBannerModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? location,
    int? displayOrder,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return AdminBannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory AdminBannerModel.fromJson(Map<String, dynamic> json) {
    return AdminBannerModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      location: json['location']?.toString() ?? 'Home Page',
      displayOrder: (json['displayOrder'] ?? 1) as int,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.tryParse(
            json['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'location': location,
      'displayOrder': displayOrder,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}