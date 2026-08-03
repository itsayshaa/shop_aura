import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/client/screens/widgets/section_card.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class LowStockWidget extends StatelessWidget {
  const LowStockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {"name": "Samsung Galaxy S24 Ultra", "stock": 3},
      {"name": "Boat Airdopes 141", "stock": 5},
      {"name": "Nike Air Max", "stock": 2},
      {"name": "Apple Watch Series 10", "stock": 1},
    ];

    return SectionCard(
      title: "Low Stock",
      icon: Icons.warning_amber_rounded,
      child: products.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 50,
                      color: AppColors.textGrey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "No low stock products",
                      style: TextStyle(fontSize: 15, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final product = products[index];

                return Row(
                  children: [
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.inventory_2_rounded,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product["name"].toString().trim().isEmpty
                                ? "No Product Name"
                                : product["name"].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Low Stock Product",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${product["stock"]} Left",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
