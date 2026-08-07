import 'package:mongo_dart/mongo_dart.dart';

class CouponModel {
  final ObjectId? id;
  final String name;
  final String description;
  final String code;
  final String type;
  final double discount;
  final DateTime expiryDate;
  final double minimumOrderAmount;
  final double maximumDiscount;
  final int usageLimit;
  final int usedCount;
  final List<String> usedBy;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CouponModel({
    this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.type,
    required this.discount,
    required this.expiryDate,
    this.minimumOrderAmount = 0,
    this.maximumDiscount = 0,
    this.usageLimit = 0,
    this.usedCount = 0,
    this.usedBy = const [],
    this.status = "Active",
    this.createdAt,
    this.updatedAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json["_id"] != null
    ? ObjectId.fromHexString(json["_id"].toString())
    : null,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      code: json["code"] ?? "",
      type: json["type"] ?? "",
      discount: (json["discount"] as num).toDouble(),
      expiryDate: DateTime.parse(json["expirydate"]),
      minimumOrderAmount:
          (json["minimumOrderAmount"] as num?)?.toDouble() ?? 0,
      maximumDiscount:
          (json["maximumDiscount"] as num?)?.toDouble() ?? 0,
      usageLimit: json["usageLimit"] ?? 0,
      usedCount: json["usedCount"] ?? 0,
      usedBy: List<String>.from(json["usedBy"] ?? []),
      status: json["status"] ?? "Active",
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
      // "_id": id,
      "name": name,
      "description":description,
      "code": code,
      "type":type,
      "discount": discount,
      "expirydate": expiryDate.toIso8601String(),
      "minimumOrderAmount": minimumOrderAmount,
      "maximumDiscount": maximumDiscount,
      "usageLimit": usageLimit,
      "usedCount": usedCount,
      "usedBy": usedBy,
      "status": status,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }

  CouponModel copyWith({
  ObjectId? id,
  String? name,
  String? description,
  String? code,
  String? type,
  double? discount,
  DateTime? expiryDate,
  double? minimumOrderAmount,
  double? maximumDiscount,
  int? usageLimit,
  int? usedCount,
  List<String>? usedBy,
  String? status,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return CouponModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    code: code ?? this.code,
    type: type ?? this.type,
    discount: discount ?? this.discount,
    expiryDate: expiryDate ?? this.expiryDate,
    minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
    maximumDiscount: maximumDiscount ?? this.maximumDiscount,
    usageLimit: usageLimit ?? this.usageLimit,
    usedCount: usedCount ?? this.usedCount,
    usedBy: usedBy ?? this.usedBy,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
}