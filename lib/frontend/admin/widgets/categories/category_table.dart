import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/models/category_model.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_action_buttons.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_status_badge.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class CategoryTable extends StatelessWidget {
  final List<CategoryModel> categories;
  final ValueChanged<CategoryModel> onEdit;
  final ValueChanged<CategoryModel> onDelete;

  const CategoryTable({
    super.key,
    required this.categories,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 950,
            ),
            child: Column(
              children: [
                _buildHeader(),

                ...categories.map(
                  (category) {
                    return _buildCategoryRow(
                      category,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      color: const Color(0xFFF8F8FA),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: _TableHeaderText(
              text: 'CATEGORY',
            ),
          ),

          Expanded(
            flex: 2,
            child: _TableHeaderText(
              text: 'PARENT CATEGORY',
            ),
          ),

          Expanded(
            flex: 2,
            child: _TableHeaderText(
              text: 'PRODUCTS',
            ),
          ),

          Expanded(
            flex: 2,
            child: _TableHeaderText(
              text: 'STATUS',
            ),
          ),

          SizedBox(
            width: 130,
            child: _TableHeaderText(
              text: 'ACTIONS',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(
    CategoryModel category,
  ) {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildCategoryInfo(
              category,
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              category.parentName == 'No Parent'
                  ? '—'
                  : category.parentName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: category.parentName == 'No Parent'
                    ? AppColors.textGrey
                    : AppColors.textDark,
                fontWeight:
                    category.parentName == 'No Parent'
                        ? FontWeight.w400
                        : FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(
                      0.08,
                    ),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Text(
                    '${category.productCount}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(width: 9),

                const Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: CategoryStatusBadge(
              isActive: category.isActive,
            ),
          ),

          SizedBox(
            width: 130,
            child: Center(
              child: CategoryActionButtons(
                onEdit: () {
                  onEdit(category);
                },
                onDelete: () {
                  onDelete(category);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryInfo(
    CategoryModel category,
  ) {
    return Row(
      children: [
        _buildCategoryImage(
          category,
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryImage(
    CategoryModel category,
  ) {
    final hasImage =
        category.imagePath != null &&
        category.imagePath!.trim().isNotEmpty;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(
          0.08,
        ),
        borderRadius: BorderRadius.circular(
          13,
        ),
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
                  color: AppColors.primary,
                  size: 25,
                );
              },
            )
          : const Icon(
              Icons.category_outlined,
              color: AppColors.primary,
              size: 25,
            ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: const Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 55,
            color: AppColors.textGrey,
          ),

          SizedBox(height: 14),

          Text(
            'No categories found',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          SizedBox(height: 6),

          Text(
            'Try changing your search or filter.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeaderText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const _TableHeaderText({
    required this.text,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.textGrey,
        letterSpacing: 0.6,
      ),
    );
  }
}