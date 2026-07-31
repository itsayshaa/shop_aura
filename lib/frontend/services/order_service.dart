import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_aura/frontend/models/order_model.dart';

class OrderService extends ChangeNotifier {
  OrderService._internal();
  static final OrderService instance = OrderService._internal();

  static const String _storageKey = 'saved_orders';

  final List<OrderModel> _orders = [];
  bool _isLoaded = false;

  List<OrderModel> get orders {
    final sorted = List<OrderModel>.from(_orders);
    sorted.sort((a, b) => b.date.compareTo(a.date)); // newest first
    return List.unmodifiable(sorted);
  }

  bool get isLoaded => _isLoaded;

  /// Loads previously saved orders from local storage.
  /// Call this once, e.g. in OrdersScreen.initState().
  Future<void> loadOrders() async {
    if (_isLoaded) return; // avoid reloading every time the screen opens

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);

      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        _orders
          ..clear()
          ..addAll(decoded.map(
            (e) => OrderModel.fromJson(e as Map<String, dynamic>),
          ));
      }
    } catch (e) {
      debugPrint('OrderService: failed to load orders — $e');
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// Call this right after a successful checkout/payment,
  /// BEFORE navigating to SuccessScreen.
  Future<void> addOrder(OrderModel order) async {
    _orders.add(order);
    notifyListeners();
    await _persist();
  }

  OrderModel? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_orders.map((o) => o.toJson()).toList());
      await prefs.setString(_storageKey, encoded);
    } catch (e) {
      debugPrint('OrderService: failed to save orders — $e');
    }
  }

  /// Optional: clear all orders (e.g. on logout)
  Future<void> clearOrders() async {
    _orders.clear();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      debugPrint('OrderService: failed to clear orders — $e');
    }
  }
}