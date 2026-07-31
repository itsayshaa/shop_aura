import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class CategoryFormSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const CategoryFormSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),

          if (subtitle != null) ...[
            const SizedBox(height: 5),

            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textGrey,
              ),
            ),
          ],

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }
}