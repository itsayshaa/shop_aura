import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductDescription extends StatelessWidget {
  final String description;

  const ProductDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Product Description",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.7,
              color: AppColors.textSoft,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}