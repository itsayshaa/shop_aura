import 'package:mongo_dart/mongo_dart.dart';

class BannerModel {
  final ObjectId? id;
  final String title;
  final String imageUrl;
  final String location;
  final int displayOrder;
  final bool isActive;
  final DateTime createdAt;

  BannerModel({
    this.id,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.displayOrder,
    required this.isActive,
    required this.createdAt,
  });

  factory BannerModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BannerModel(
      id: json['_id'] is ObjectId
          ? json['_id'] as ObjectId
          : json['_id'] != null
              ? ObjectId.parse(
                  json['_id'].toString(),
                )
              : null,

      title: json['title']?.toString() ?? '',

      imageUrl: json['imageUrl']?.toString() ?? '',

      location: json['location']?.toString() ??
          'Home Page',

      displayOrder:
          (json['displayOrder'] as num?)
                  ?.toInt() ??
              0,

      isActive:
          json['isActive'] as bool? ??
              true,

      createdAt:
          json['createdAt'] is DateTime
              ? json['createdAt'] as DateTime
              : DateTime.tryParse(
                    json['createdAt']
                            ?.toString() ??
                        '',
                  ) ??
                  DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,

      'title': title,

      'imageUrl': imageUrl,

      'location': location,

      'displayOrder': displayOrder,

      'isActive': isActive,

      'createdAt': createdAt.toIso8601String(),
    };
  }

  BannerModel copyWith({
    ObjectId? id,
    String? title,
    String? imageUrl,
    String? location,
    int? displayOrder,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return BannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      displayOrder:
          displayOrder ??
              this.displayOrder,
      isActive:
          isActive ??
              this.isActive,
      createdAt:
          createdAt ??
              this.createdAt,
    );
  }
}