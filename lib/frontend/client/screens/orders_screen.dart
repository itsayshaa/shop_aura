import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:shop_aura/backend/models/client/orderModel.dart';
import 'package:shop_aura/frontend/services/order_service.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/client/screens/home_screen.dart';
import 'package:shop_aura/frontend/client/screens/main_navigation_screen.dart';
import 'package:shop_aura/frontend/client/screens/widgets/bottom_nav_bar.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    OrderService.instance.loadOrders();
  }

  void _handleBackToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  void _handleNavTap(BuildContext context, int index) {
    if (index == 3) return; // already on Orders

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MainNavigationScreen(initialIndex: index)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => _handleBackToHome(context),
        ),
        title: const Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListenableBuilder(
        listenable: OrderService.instance,
        builder: (context, _) {
          final orders = OrderService.instance.orders;

          if (orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/lottieanimtion/emptycart/truck.json',
                      width: 220,
                      height: 220,
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No orders yet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Once you place an order, it will show up here.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _OrderCard(order: order);
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (index) => _handleNavTap(context, index),
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final dateStr =
    DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt);

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order #${order.orderNumber}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    _StatusChip(status: order.orderStatus),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  dateStr,
                  style: const TextStyle(
                    color: AppColors.textSoft,
                    fontSize: 12,
                  ),
                ),
                const Divider(height: 24, color: AppColors.border),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${order.products.length} ${order.products.length == 1 ? 'Item' : 'products'}",
                      style: const TextStyle(
                        color: AppColors.textSoft,
                        fontSize: 13.5,
                      ),
                    ),
                    Text(
                      "₹${order.totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (_expanded) ...[
            const Divider(height: 1, color: AppColors.border),
            Container(
              color: AppColors.background.withOpacity(0.4),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "products ORDERED",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSoft,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.products.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) {
                      final item = order.products[idx];
                      return Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.image,
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 45,
                                height: 45,
                                color: AppColors.secondarySoft,
                                child: const Icon(Icons.image_not_supported, size: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Qty: ${item.quantity}  •  ₹${item.price}",
                                  style: const TextStyle(
                                    color: AppColors.textSoft,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "₹${item.price * item.quantity}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Divider(height: 24, color: AppColors.border),
                  const Text(
                    "DELIVERY ADDRESS",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSoft,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
Text(
  order.shippingAddress.fullName,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 13,
  ),
),
Text(
  "Phone: ${order.shippingAddress.phone}",
),
Text(
  "${order.shippingAddress.address}, "
  "${order.shippingAddress.city}, "
  "${order.shippingAddress.state} - "
  "${order.shippingAddress.pincode}",
),
                  const Divider(height: 24, color: AppColors.border),
                  const Text(
                    "PAYMENT METHOD",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSoft,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.paymentMethod.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.text,
                        ),
                      ),
                      if (order.paymentStatus != null)
                        Text(
                          "Status: ${order.paymentStatus}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: order.paymentStatus?.toLowerCase() == 'refunded'
                                ? Colors.purple
                                : order.paymentStatus?.toLowerCase() == 'paid'
                                    ? AppColors.success
                                    : Colors.orange,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 12),
                  if (order.refundStatus != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info_outline, size: 16, color: Colors.amber),
                              const SizedBox(width: 6),
                              Text(
                                "Refund Status: ${order.refundStatus}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          if (order.refundReason != null && order.refundReason!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              "Reason: ${order.refundReason}",
                              style: const TextStyle(fontSize: 12, color: AppColors.textSoft),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.replay_rounded, size: 16),
                        label: const Text("Request Refund"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _showRefundDialog(context, order),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          InkWell(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _expanded ? "Hide Details" : "View Details",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRefundDialog(BuildContext context, OrderModel order) {
    String selectedReason = "Defective / Damaged Item";
    final notesController = TextEditingController();
    final reasons = [
      "Defective / Damaged Item",
      "Received Wrong Product",
      "Item Quality Not as Expected",
      "Delayed Delivery",
      "Other"
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Request Refund", style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order #${order.id}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSoft),
                    ),
                    const SizedBox(height: 12),
                    const Text("Select Reason for Refund:"),
                    const SizedBox(height: 6),
                    ...reasons.map((r) => RadioListTile<String>(
                          title: Text(r, style: const TextStyle(fontSize: 13)),
                          value: r,
                          groupValue: selectedReason,
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => selectedReason = val);
                            }
                          },
                        )),
                    const SizedBox(height: 10),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: "Additional details (optional)",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final reasonStr = selectedReason +
                        (notesController.text.trim().isNotEmpty
                            ? " - ${notesController.text.trim()}"
                            : "");
                    await OrderService.instance.requestRefund(order.id!.toHexString(), reasonStr);
                    if (context.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Refund request submitted successfully!"),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  child: const Text("Submit Request"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'processing':
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade700;
        break;
      case 'shipped':
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade700;
        break;
      case 'delivered':
        bg = AppColors.successBackground;
        fg = AppColors.success;
        break;
      case 'cancelled':
        bg = Colors.red.shade50;
        fg = Colors.red.shade700;
        break;
      default:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}