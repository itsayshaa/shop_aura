import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_aura/backend/models/client/orderModel.dart';

class OrderService extends ChangeNotifier {
  OrderService._internal();
  static final OrderService instance = OrderService._internal();

  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  Future<void> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? ordersJson = prefs.getString('saved_orders');
      if (ordersJson != null) {
        final List decoded = jsonDecode(ordersJson);
        _orders.clear();
        _orders.addAll(decoded.map((o) => OrderModel.fromJson(o)).toList());
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading orders: $e");
    }
  }

  Future<void> saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(_orders.map((o) => o.toJson()).toList());
      await prefs.setString('saved_orders', encoded);
    } catch (e) {
      debugPrint("Error saving orders: $e");
    }
  }

  Future<void> addOrder(OrderModel order) async {
    _orders.insert(0, order); // Add new orders at the top
    notifyListeners();
    await saveOrders();
  }
}
