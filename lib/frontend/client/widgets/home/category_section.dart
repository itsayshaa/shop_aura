import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class CategorySection extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final int selectedIndex;
  final Function(int) onCategoryTap;

  const CategorySection({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategoryTap,
  });

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final bool isSelected = widget.selectedIndex == index;

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              widget.onCategoryTap(index);
            },
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  height: 60,
                  width: 60,
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
                  ),
                  child: Icon(
                    category["icon"],
                    color: isSelected
                        ? Colors.white
                        : AppColors.primary,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: 72,
                  child: Text(
                    category["title"],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          
                          : AppColors.textSoft,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}