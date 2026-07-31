import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/models/category_model.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_action_buttons.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_status_badge.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class CategoryMobileCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryMobileCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryImage(),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      category.slug,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),

                    const SizedBox(height: 10),

                    CategoryStatusBadge(
                      isActive: category.isActive,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              CategoryActionButtons(
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.account_tree_outlined,
                  label: 'Parent',
                  value: category.parentName == 'No Parent'
                      ? 'Main Category'
                      : category.parentName,
                ),
              ),

              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade200,
              ),

              Expanded(
                child: _buildInfoItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Products',
                  value: '${category.productCount}',
                ),
              ),
            ],
          ),

          if (category.description.trim().isNotEmpty) ...[
            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FA),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                category.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryImage() {
    final hasImage =
        category.imagePath != null &&
        category.imagePath!.trim().isNotEmpty;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Image.network(
              category.imagePath!,
              fit: BoxFit.cover,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return const Icon(
                  Icons.category_outlined,
                  size: 28,
                  color: AppColors.primary,
                );
              },
            )
          : const Icon(
              Icons.category_outlined,
              size: 28,
              color: AppColors.primary,
            ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}