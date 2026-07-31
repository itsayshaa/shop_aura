import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductImageBox extends StatelessWidget {
  const ProductImageBox({
    super.key,
    this.size = 55,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.inventory_2_outlined,
        color: AppColors.primary,
        size: size * 0.49,
      ),
    );
  }
}