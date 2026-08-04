import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_aura/backend/models/client/orderModel.dart';
import 'package:shop_aura/main.dart';
import 'package:shop_aura/frontend/services/authService.dart';

class OrderService extends ChangeNotifier {
  OrderService._internal();
  static final OrderService instance = OrderService._internal();

  static const String _storageKey = 'saved_orders';

  final List<OrderModel> _orders = [];
  bool _isLoaded = false;
  bool _isLoading = false;

  List<OrderModel> get orders {
    final sorted = List<OrderModel>.from(_orders);
    sorted.sort(
  (a,b)=> b.createdAt.compareTo(a.createdAt)
); // newest first
    return List.unmodifiable(sorted);
  }

  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;

  String get _baseUrl => Apiconfig.baseUrl.isNotEmpty ? Apiconfig.baseUrl : "http://localhost:5000";

  /// Loads orders for user or admin from MongoDB backend API.
  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await Authservice.getToken();
      final url = token != null ? "$_baseUrl/order/" : "$_baseUrl/order/admin/all";
      final headers = <String, String>{
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final response = await http.get(Uri.parse(url), headers: headers);
      if(response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> decoded = jsonDecode(response.body) as List<dynamic>;
        _orders
          ..clear()
          ..addAll(decoded.map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e))));
        await _persist();
      } else {
        await _loadFromLocal();
      }
    } catch (e) {
      debugPrint('OrderService: failed to fetch orders from server, loading from local — $e');
      await _loadFromLocal();
    } finally {
      _isLoaded = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Explicitly loads all orders for the Admin screen from MongoDB.
  Future<void> loadAdminOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/order/admin/all"),
        headers: {"Content-Type": "application/json"},
      );
      if(response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> decoded = jsonDecode(response.body) as List<dynamic>;
        _orders
          ..clear()
          ..addAll(decoded.map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e))));
        await _persist();
      } else {
        await _loadFromLocal();
      }
    } catch (e) {
      debugPrint('OrderService: failed to fetch admin orders from server — $e');
      await _loadFromLocal();
    } finally {
      _isLoaded = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);

      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        _orders
          ..clear()
          ..addAll(decoded.map(
            (e) => OrderModel.fromJson(Map<String, dynamic>.from(e)),
          ));
      }
    } catch (e) {
      debugPrint('OrderService: failed to load local orders — $e');
    }
  }

  /// Call this right after a successful checkout/payment
  Future<void> addOrder(OrderModel order) async {
    _orders.add(order);
    notifyListeners();
    await _persist();

    try {
      final token = await Authservice.getToken();
      final response = await http.post(
        Uri.parse("$_baseUrl/order/create"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(order.toJson()),
      );
      if(response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        if (body["order"] != null) {
          final serverOrder = OrderModel.fromJson(Map<String, dynamic>.from(body["order"]));
          final idx = _orders.indexWhere(
  (o) => o.id?.toHexString() == order.id?.toHexString(),
);
          if (idx != -1) {
            _orders[idx] = serverOrder;
          }
          await _persist();
        }
      }
    } catch (e) {
      debugPrint('OrderService: failed to post order to server — $e');
    }
  }

OrderModel? getOrderById(String id) {
  try {
    return _orders.firstWhere(
      (o) => o.id?.toHexString() == id,
    );
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

  /// Request a refund for a given order
  Future<void> requestRefund(String orderId, String reason) async {
    final index = _orders.indexWhere((o) => o.id?.toHexString() == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        refundStatus: 'Requested',
        refundReason: reason,
        refundDate: DateTime.now(),
      );
      notifyListeners();
      await _persist();
    }

    try {
      await http.post(
        Uri.parse("$_baseUrl/order/refund/request"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"orderId": orderId, "reason": reason}),
      );
    } catch (e) {
      debugPrint('OrderService: requestRefund server call error — $e');
    }
  }

  /// Update order delivery status (Admin action)
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final index = _orders.indexWhere((o) => o.id?.toHexString() == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(orderStatus: newStatus);
      notifyListeners();
      await _persist();
    }

    try {
      await http.post(
        Uri.parse("$_baseUrl/order/admin/update-status"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"orderId": orderId, "status": newStatus}),
      );
    } catch (e) {
      debugPrint('OrderService: updateOrderStatus server call error — $e');
    }
  }

  /// Process refund action: 'approve', 'reject', or 'refund' (Admin action)
  Future<void> processRefund(String orderId, String action) async {
    final index = _orders.indexWhere((o) => o.id?.toHexString() == orderId);
    if (index != -1) {
      String refundStatus;
      String paymentStatus;

      if (action.toLowerCase() == 'approve') {
        refundStatus = 'Approved';
        paymentStatus = 'Refund Pending';
      } else if (action.toLowerCase() == 'reject') {
        refundStatus = 'Rejected';
        paymentStatus = 'Paid';
      } else {
        refundStatus = 'Refunded';
        paymentStatus = 'Refunded';
      }

      _orders[index] = _orders[index].copyWith(
        refundStatus: refundStatus,
        paymentStatus: paymentStatus,
      );
      notifyListeners();  
      await _persist();
    }

    try {
      await http.post(
        Uri.parse("$_baseUrl/order/admin/refund/process"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"orderId": orderId, "action": action}),
      );
    } catch (e) {
      debugPrint('OrderService: processRefund server call error — $e');
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