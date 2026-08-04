import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/client/screens/widgets/section_card.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class RecentOrdersWidget extends StatelessWidget {
  const RecentOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {
        "id": "#1001",
        "customer": "John Doe",
        "amount": "₹2,499",
        "status": "Delivered",
      },
      {
        "id": "#1002",
        "customer": "Afsal",
        "amount": "₹899",
        "status": "Pending",
      },
      {
        "id": "#1003",
        "customer": "Sinan",
        "amount": "₹1,299",
        "status": "Cancelled",
      },
    ];

    return SectionCard(
      title: "Recent Orders",
      icon: Icons.receipt_long_rounded,
      child: orders.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 50,
                      color: AppColors.textGrey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "No recent orders",
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final order = orders[index];

                return Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order["id"]!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order["customer"]!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          order["amount"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _StatusChip(status: order["status"]!),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case "Delivered":
        bgColor = Colors.green.shade100;
        textColor = Colors.green;
        break;
      case "Pending":
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange;
        break;
      case "Cancelled":
        bgColor = Colors.red.shade100;
        textColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}