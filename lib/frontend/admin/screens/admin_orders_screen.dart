import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_aura/frontend/models/order_model.dart';
import 'package:shop_aura/frontend/services/order_service.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class AdminOrdersScreen extends StatefulWidget {
  final bool initialRefundsFilter;
  const AdminOrdersScreen({super.key, this.initialRefundsFilter = false});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    if (widget.initialRefundsFilter) {
      _selectedFilter = 'Refund Requests';
    }
    OrderService.instance.loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: OrderService.instance,
      builder: (context, _) {
        final allOrders = OrderService.instance.orders;
        final filteredOrders = allOrders.where((order) {
          if (_selectedFilter == 'Refund Requests') {
            return order.refundStatus != null;
          } else if (_selectedFilter == 'Processing') {
            return order.status.toLowerCase() == 'processing';
          } else if (_selectedFilter == 'Shipped') {
            return order.status.toLowerCase() == 'shipped';
          } else if (_selectedFilter == 'Delivered') {
            return order.status.toLowerCase() == 'delivered';
          } else if (_selectedFilter == 'Cancelled') {
            return order.status.toLowerCase() == 'cancelled';
          }
          return true;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  _buildFilterChip('All', allOrders.length),
                  _buildFilterChip(
                    'Refund Requests',
                    allOrders.where((o) => o.refundStatus != null).length,
                    badgeColor: Colors.amber.shade800,
                  ),
                  _buildFilterChip(
                    'Processing',
                    allOrders.where((o) => o.status.toLowerCase() == 'processing').length,
                  ),
                  _buildFilterChip(
                    'Shipped',
                    allOrders.where((o) => o.status.toLowerCase() == 'shipped').length,
                  ),
                  _buildFilterChip(
                    'Delivered',
                    allOrders.where((o) => o.status.toLowerCase() == 'delivered').length,
                  ),
                  _buildFilterChip(
                    'Cancelled',
                    allOrders.where((o) => o.status.toLowerCase() == 'cancelled').length,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filteredOrders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            "No ${_selectedFilter == 'All' ? 'orders' : _selectedFilter.toLowerCase()} found",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredOrders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        return _AdminOrderCard(order: filteredOrders[index]);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(String label, int count, {Color? badgeColor}) {
    final bool isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : (badgeColor ?? AppColors.accent),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.accent : Colors.white,
                ),
              ),
            ),
          ],
        ),
        selected: isSelected,
        selectedColor: AppColors.accent,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textDark,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          if (selected) {
            setState(() => _selectedFilter = label);
          }
        },
      ),
    );
  }
}

class _AdminOrderCard extends StatefulWidget {
  final OrderModel order;
  const _AdminOrderCard({required this.order});

  @override
  State<_AdminOrderCard> createState() => _AdminOrderCardState();
}

class _AdminOrderCardState extends State<_AdminOrderCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(order.date);

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Summary Row
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: order.refundStatus != null ? Colors.amber.shade50.withOpacity(0.5) : Colors.white,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.accent.withOpacity(0.1),
                    child: const Icon(Icons.receipt_long_rounded, color: AppColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Order #${order.id.substring(0, order.id.length > 10 ? 10 : order.id.length).toUpperCase()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _AdminStatusBadge(status: order.status),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$dateStr • ${order.name}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${order.totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.accent,
                        ),
                      ),
                      Icon(
                        _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (_expanded) ...[
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECTION 1: CUSTOMER INFORMATION
                  _buildSectionHeader(Icons.person_outline, "1. CUSTOMER INFORMATION"),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9FB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEBEBEB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${order.name}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Phone: ${order.phone}",
                          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Shipping Address: ${order.address}",
                          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // SECTION 2: ORDER INFORMATION
                  _buildSectionHeader(Icons.shopping_bag_outlined, "2. ORDER INFORMATION"),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9FB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEBEBEB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Order Status:", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            DropdownButton<String>(
                              value: ['processing', 'shipped', 'delivered', 'cancelled']
                                      .contains(order.status.toLowerCase())
                                  ? order.status.toLowerCase()
                                  : 'processing',
                              isDense: true,
                              underline: const SizedBox.shrink(),
                              items: const [
                                DropdownMenuItem(value: 'processing', child: Text('Processing')),
                                DropdownMenuItem(value: 'shipped', child: Text('Shipped')),
                                DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
                                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                              ],
                              onChanged: (newStatus) {
                                if (newStatus != null) {
                                  final capitalized = newStatus[0].toUpperCase() + newStatus.substring(1);
                                  OrderService.instance.updateOrderStatus(order.id, capitalized);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Order status updated to $capitalized")),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text("Order ID: ${order.id}", style: const TextStyle(fontSize: 12.5, color: Colors.grey)),
                        Text("Order Date: $dateStr", style: const TextStyle(fontSize: 12.5, color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // SECTION 3: PRODUCT DETAILS
                  _buildSectionHeader(Icons.inventory_2_outlined, "3. PRODUCT DETAILS"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9FB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEBEBEB)),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEBEBEB)),
                      itemBuilder: (context, idx) {
                        final item = order.items[idx];
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  item.image,
                                  width: 42,
                                  height: 42,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 42,
                                    height: 42,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.image_not_supported, size: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                    ),
                                    Text(
                                      "Qty: ${item.quantity} x ₹${item.price}",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // SECTION 4: PAYMENT DETAILS
                  _buildSectionHeader(Icons.payment_outlined, "4. PAYMENT DETAILS"),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9FB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEBEBEB)),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow("Payment Method", order.paymentMethod.toUpperCase()),
                        _buildDetailRow(
                          "Payment Status",
                          order.paymentStatus ?? (order.paymentMethod.toLowerCase() == 'cod' ? 'Pending' : 'Paid'),
                        ),
                        _buildDetailRow("Total Amount", "₹${order.totalAmount.toStringAsFixed(2)}", isBold: true),
                        _buildDetailRow(
                          "Transaction ID",
                          order.transactionId ?? "TXN_${order.id.substring(0, order.id.length > 8 ? 8 : order.id.length)}",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // SECTION 5: REFUND SECTION
                  _buildSectionHeader(Icons.replay_outlined, "5. REFUND SECTION"),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: order.refundStatus != null ? Colors.amber.shade50 : const Color(0xFFF9F9FB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: order.refundStatus != null ? Colors.amber.shade300 : const Color(0xFFEBEBEB),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Refund Status:", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: order.refundStatus == 'Approved'
                                    ? Colors.blue.shade100
                                    : order.refundStatus == 'Refunded'
                                        ? Colors.green.shade100
                                        : order.refundStatus == 'Rejected'
                                            ? Colors.red.shade100
                                            : order.refundStatus == 'Requested'
                                                ? Colors.amber.shade100
                                                : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                order.refundStatus ?? 'None Requested',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: order.refundStatus == 'Approved'
                                      ? Colors.blue.shade900
                                      : order.refundStatus == 'Refunded'
                                          ? Colors.green.shade900
                                          : order.refundStatus == 'Rejected'
                                              ? Colors.red.shade900
                                              : order.refundStatus == 'Requested'
                                                  ? Colors.amber.shade900
                                                  : Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (order.refundReason != null && order.refundReason!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text("Reason: ${order.refundReason}", style: const TextStyle(fontSize: 13)),
                        ],
                        if (order.refundRequestedAt != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            "Requested At: ${DateFormat('dd MMM yyyy, hh:mm a').format(order.refundRequestedAt!)}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                        const SizedBox(height: 12),
                        // Refund Action Controls for Admin
                        Row(
                          children: [
                            if (order.refundStatus == 'Requested') ...[
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () async {
                                    await OrderService.instance.processRefund(order.id, 'approve');
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Refund Approved")),
                                      );
                                    }
                                  },
                                  child: const Text("Approve Refund"),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade600,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () async {
                                    await OrderService.instance.processRefund(order.id, 'reject');
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Refund Rejected")),
                                      );
                                    }
                                  },
                                  child: const Text("Reject Refund"),
                                ),
                              ),
                            ] else if (order.refundStatus == 'Approved') ...[
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.check_circle_outline, size: 18),
                                  label: const Text("Process Refund Payment"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade700,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () async {
                                    await OrderService.instance.processRefund(order.id, 'refund');
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Refund payment processed successfully!")),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ] else if (order.refundStatus == 'Refunded') ...[
                              const Row(
                                children: [
                                  Icon(Icons.verified, color: Colors.green, size: 18),
                                  SizedBox(width: 6),
                                  Text("Refund Completed & Settled", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                            ] else ...[
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.replay, size: 16),
                                  label: const Text("Initiate Admin Refund"),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.accent,
                                    side: const BorderSide(color: AppColors.accent),
                                  ),
                                  onPressed: () async {
                                    await OrderService.instance.requestRefund(order.id, "Initiated by Admin");
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Refund process initiated by Admin")),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.accent),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? AppColors.accent : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminStatusBadge extends StatelessWidget {
  final String status;
  const _AdminStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'processing':
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade800;
        break;
      case 'shipped':
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade800;
        break;
      case 'delivered':
        bg = Colors.green.shade50;
        fg = Colors.green.shade800;
        break;
      case 'cancelled':
        bg = Colors.red.shade50;
        fg = Colors.red.shade800;
        break;
      default:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
