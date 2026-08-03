import 'package:mongo_dart/mongo_dart.dart';

class OrderItemModel {
  ObjectId productId;
  String name;
  String image;
  String color;
  String size;
  double price;
  int quantity;
  double subtotal;

  OrderItemModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.color,
    required this.size,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json["productId"] as ObjectId,
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      color: json["color"] ?? "",
      size: json["size"] ?? "",
      price: (json["price"] as num).toDouble(),
      quantity: json["quantity"],
      subtotal: (json["subtotal"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "name": name,
      "image": image,
      "color": color,
      "size": size,
      "price": price,
      "quantity": quantity,
      "subtotal": subtotal,
    };
  }
}

class ShippingAddressModel {
  String fullName;
  String phone;
  String address;
  String city;
  String state;
  String pincode;
  String country;

  ShippingAddressModel({
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.country = "India",
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      fullName: json["fullName"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      pincode: json["pincode"] ?? "",
      country: json["country"] ?? "India",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "phone": phone,
      "address": address,
      "city": city,
      "state": state,
      "pincode": pincode,
      "country": country,
    };
  }
}

class OrderModel {
  ObjectId? id;

  ObjectId userId;
  int orderNumber;

  List<OrderItemModel> products;

  String paymentMethod;
  String paymentStatus;
  String orderStatus;

  ObjectId? couponApplied;

  double subTotal;
  double discount;
  double tax;
  double shipping;
  double totalAmount;

  ShippingAddressModel shippingAddress;

  DateTime? shipDate;

  bool refundRequested;
  String refundStatus;
  String refundReason;
  DateTime? refundDate;

  DateTime createdAt;
  DateTime updatedAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.orderNumber,
    required this.products,
    required this.paymentMethod,
    this.paymentStatus = "Pending",
    this.orderStatus = "Pending",
    this.couponApplied,
    required this.subTotal,
    this.discount = 0,
    this.tax = 0,
    this.shipping = 0,
    required this.totalAmount,
    required this.shippingAddress,
    this.shipDate,
    this.refundRequested = false,
    this.refundStatus = "None",
    this.refundReason = "",
    this.refundDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["_id"] as ObjectId?,
      userId: json["userId"] as ObjectId,
      orderNumber: json["orderNumber"],
      products: (json["products"] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
      paymentMethod: json["paymentMethod"],
      paymentStatus: json["paymentStatus"] ?? "Pending",
      orderStatus: json["orderStatus"] ?? "Pending",
      couponApplied: json["couponApplied"] as ObjectId?,
      subTotal: (json["subTotal"] as num).toDouble(),
      discount: (json["discount"] as num).toDouble(),
      tax: (json["tax"] as num).toDouble(),
      shipping: (json["shipping"] as num).toDouble(),
      totalAmount: (json["totalAmount"] as num).toDouble(),
      shippingAddress:
          ShippingAddressModel.fromJson(json["shippingAddress"]),
      shipDate: json["shipDate"] != null
          ? DateTime.parse(json["shipDate"].toString())
          : null,
      refundRequested: json["refundRequested"] ?? false,
      refundStatus: json["refundStatus"] ?? "None",
      refundReason: json["refundReason"] ?? "",
      refundDate: json["refundDate"] != null
          ? DateTime.parse(json["refundDate"].toString())
          : null,
      createdAt: DateTime.parse(json["createdAt"].toString()),
      updatedAt: DateTime.parse(json["updatedAt"].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "orderNumber": orderNumber,
      "products": products.map((e) => e.toJson()).toList(),
      "paymentMethod": paymentMethod,
      "paymentStatus": paymentStatus,
      "orderStatus": orderStatus,
      "couponApplied": couponApplied,
      "subTotal": subTotal,
      "discount": discount,
      "tax": tax,
      "shipping": shipping,
      "totalAmount": totalAmount,
      "shippingAddress": shippingAddress.toJson(),
      "shipDate": shipDate?.toIso8601String(),
      "refundRequested": refundRequested,
      "refundStatus": refundStatus,
      "refundReason": refundReason,
      "refundDate": refundDate?.toIso8601String(),
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}