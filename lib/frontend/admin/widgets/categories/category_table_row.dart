import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/models/category_model.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_action_buttons.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_status_badge.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class CategoryTableRow extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryTableRow({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            child: _buildCategoryImage(),
          ),

          Expanded(
            flex: 3,
            child: Text(
              category.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              category.slug,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textGrey,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              category.parentName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
          ),

          SizedBox(
            width: 105,
            child: Text(
              '${category.productCount}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),

          SizedBox(
            width: 145,
            child: CategoryStatusBadge(
              isActive: category.isActive,
            ),
          ),

          SizedBox(
            width: 110,
            child: CategoryActionButtons(
              onEdit: onEdit,
              onDelete: onDelete,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryImage() {
    if (category.imagePath != null &&
        category.imagePath!.trim().isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          category.imagePath!,
          width: 58,
          height: 58,
          fit: BoxFit.cover,
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return _imagePlaceholder();
          },
        ),
      );
    }

    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.category_outlined,
        color: AppColors.primary,
        size: 27,
      ),
    );
  }
}