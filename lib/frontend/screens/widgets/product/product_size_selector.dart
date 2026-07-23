import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductSizeSelector extends StatelessWidget {
  final List<String> sizes;
  final int selectedIndex;
  final ValueChanged<int> onSizeSelected;

  const ProductSizeSelector({
    super.key,
    required this.sizes,
    required this.selectedIndex,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Size",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
              sizes.length,
              (index) {
                final bool isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () => onSizeSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 55,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      sizes[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : AppColors.text,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}