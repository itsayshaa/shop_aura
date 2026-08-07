import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shop_aura/backend/database/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shop_aura/backend/models/client/coupon/CouponModel.dart';

const _headers = {
  "Content-Type":"application/json"
};

Future<Response> getCoupons(Request request) async {
  final coupons = await MongoService.coupons.find().toList();
print(coupons);
  return Response.ok(
    jsonEncode(coupons),
    headers: {
      "Content-Type": "application/json",
    },
  );
}
Future<Response> createcoupon(Request request) async {
  try{
  final body = await request.readAsString();
  final data = jsonDecode(body);

  final existing = await MongoService.coupons.findOne(
    where.eq("code", data["code"]),
  );

  if (existing != null) {
    return Response(
      400,
      body: jsonEncode({"success": false, "message": "coupon already exists"}),
      headers: _headers
    );
  }
  final coupon = CouponModel.fromJson(data);

  await MongoService.coupons.insertOne({
    ...coupon.toJson(),
    "createdAt":DateTime.now().toIso8601String(),
  });

  return Response.ok(
    jsonEncode({"success": true, "message": "coupon Added Success"}),
    headers: _headers
  );
  }catch(e){
    return Response.internalServerError(
      body: jsonEncode({
        "success":true,
        "message":e.toString()
      })
    );
  }
}


  Future<Response> deleteCoupon(Request request)async{
    try{
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final id = data["_id"];
      if(id == null){
        return Response(
          400,
          body: jsonEncode({
            "success":false,
            "message":"Coupen id is required"
          }),
          headers: _headers
        );
      }
      final result = await MongoService.coupons.deleteOne(
        where.eq("_id",ObjectId.fromHexString(id))
      );
      if(!result.isSuccess){
        return Response(
          404,
          body: jsonEncode({
            "success":false,
            "message":"Coupon not found"
          }),
          headers: _headers
        );
      }

      return Response.ok(
        jsonEncode({
          "success":true,
          "message":"coupon deleted successfully"
        }),
        headers: _headers
      );
    }catch(e){
      return Response(
        500,
        body: jsonEncode({
          "success":false,
          "message":e.toString()
        }),
        headers: _headers
      );
    }
  }

Future<Response> changeCouponStatus(Request request) async {
  try {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final id = data["_id"];
    final status = data["status"];

    if (id == null || status == null) {
      return Response(
        400,
        body: jsonEncode({
          "success": false,
          "message": "Id and status are required"
        }),
        headers: _headers,
      );
    }

    final result = await MongoService.coupons.updateOne(
      where.eq("_id", ObjectId.fromHexString(id)),
      modify
          .set("status", status)
          .set("updatedAt", DateTime.now().toIso8601String()),
    );

    if (!result.isSuccess) {
      return Response(
        404,
        body: jsonEncode({
          "success": false,
          "message": "Coupon not found"
        }),
        headers: _headers,
      );
    }

    return Response.ok(
      jsonEncode({
        "success": true,
        "message": "Coupon status updated successfully"
      }),
      headers: _headers,
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        "success": false,
        "message": e.toString(),
      }),
      headers: _headers,
    );
  }
}

Future<Response> updateCoupon(Request request) async {
  try {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final id = data["_id"];

    if (id == null) {
      return Response(
        400,
        body: jsonEncode({
          "success": false,
          "message": "Coupon id required",
        }),
        headers: _headers,
      );
    }
    print("mongoId ${data["id"]}");
    final result = await MongoService.coupons.updateOne(
      where.eq("_id", ObjectId.fromHexString(id)),
      modify
          .set("name", data["name"])
          .set("description", data["description"])
          .set("code", data["code"])
          .set("type", data["type"])
          .set("discount", data["discount"])
          .set("expirydate", data["expirydate"])
          .set("minimumOrderAmount", data["minimumOrderAmount"])
          .set("maximumDiscount", data["maximumDiscount"])
          .set("usageLimit", data["usageLimit"])
          .set("status", data["status"])
          .set("updatedAt", DateTime.now().toIso8601String()),
    );

    if (!result.isSuccess) {
      return Response(
        404,
        body: jsonEncode({
          "success": false,
          "message": "Coupon not found",
        }),
        headers: _headers,
      );
    }
    print("isSuccess: ${result.isSuccess}");
print("nModified: ${result.nModified}");
print("nMatched: ${result.nMatched}");
    return Response.ok(
      jsonEncode({
        "success": true,
        "message": "Coupon updated successfully",
      }),
      headers: _headers,
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        "success": false,
        "message": e.toString(),
      }),
      headers: _headers,
    );
  }
}