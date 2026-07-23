import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductPrice extends StatelessWidget {
  final double price;
  final double oldPrice;
  final int discount;

  const ProductPrice({
    super.key,
    required this.price,
    required this.oldPrice,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// Current Price
          Text(
            "₹${price.toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 12),

          /// Old Price
          Text(
            "₹${oldPrice.toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textSoft,
              decoration: TextDecoration.lineThrough,
            ),
          ),

          const Spacer(),

          /// Discount Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$discount% OFF",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}