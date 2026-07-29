import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.border,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColors.primary.withOpacity(.18),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withOpacity(.03),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : AppColors.text,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              child: Text(title),
            ),
          ),
        ),
      ),
    );
  }
}