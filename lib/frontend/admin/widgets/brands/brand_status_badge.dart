import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class BrandStatusBadge extends StatelessWidget {
  final bool isActive;

  const BrandStatusBadge({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isActive
        ? AppColors.primary.withOpacity(0.10)
        : Colors.grey.withOpacity(0.12);

    final Color contentColor = isActive
        ? AppColors.primary
        : AppColors.textGrey;

    final IconData statusIcon = isActive
        ? Icons.check_circle_outline_rounded
        : Icons.pause_circle_outline_rounded;

    final String statusText = isActive
        ? 'Active'
        : 'Inactive';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 16,
            color: contentColor,
          ),

          const SizedBox(width: 6),

          Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: contentColor,
            ),
          ),
        ],
      ),
    );
  }
}