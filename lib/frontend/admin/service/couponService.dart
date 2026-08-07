import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shop_aura/backend/models/client/coupon/CouponModel.dart';
import 'package:shop_aura/main.dart';

class CouponService extends ChangeNotifier{
  CouponService._internal();
  static final CouponService instance = CouponService._internal();
  static final baseUrl = Apiconfig.baseUrl;
  late List<CouponModel> _coupons = [];
  bool _isLoading = false;

  List<CouponModel> get coupons => _coupons;
  bool get isLoading => _isLoading;

  Future<String> createCoupon(CouponModel coupon) async{
    try{
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse(
          "$baseUrl/coupon/create"
        ),
        body: jsonEncode(coupon.toJson()),
        headers: {"Content-Type":"application/json"}
      );

      if(response.statusCode == 200 || response.statusCode == 201){
        return "coupon created Successfully";
      }
      final data = jsonDecode(response.body);
      return data["message"];
    }catch(e){
      return e.toString();
    }
  }

  Future<List<CouponModel>> getCoupons()async{
    try{
      _isLoading = true;
      notifyListeners();
      final response = await http.get(
        Uri.parse("$baseUrl/coupon/"),
        headers: {"Content-Type":"application/json"}
      );

      if(response.statusCode== 200 || response.statusCode == 201){
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => CouponModel.fromJson(e)).toList();
      }else{
        throw Exception("Failed to load Coupons: ${response.body}");
      }
    }catch(e){
      throw  Exception(e.toString());
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> deleteCoupon(
     ObjectId id
  )async{

    try{
      final response = await http.delete(
        Uri.parse("$baseUrl/coupon/delete"),
        body: jsonEncode({
          "_id":id.toHexString()
        }),
        headers: {"Content-Type":"application/json"}
      );
      if(response.statusCode != 200 &&  response.statusCode != 201){
        throw Exception(response.body);
      }
      final data = jsonDecode(response.body);
      return data["message"];
    }catch(e){
      throw Exception(e.toString());
    }
  }

Future<String> changeCouponStatus(ObjectId? id, String status) async {
  try {
    if (id == null) {
      throw Exception("Coupon id is null");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/coupon/status"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "_id": id.toHexString(),
        "status": status,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data["message"];
    }

    throw Exception(data["message"]);
  } catch (e) {
    throw Exception(e.toString());
  }
}


Future<String> updateCoupon(
  ObjectId id,
  CouponModel coupon,
) async {
  final response = await http.put(
    Uri.parse("$baseUrl/coupon/update"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "_id": id.toHexString(),
      ...coupon.toJson(),
    }),
  );

  final data = jsonDecode(response.body);
  print(data);
  if (response.statusCode == 200) {
    return data["message"];
  }

  throw Exception(data["message"]);
}
}