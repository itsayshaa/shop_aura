import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class CategoryActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryActionButtons({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: 'Edit Category',
          child: _actionButton(
            icon: Icons.edit_outlined,
            tooltipColor: AppColors.primary,
            onPressed: onEdit,
          ),
        ),

        const SizedBox(width: 8),

        Tooltip(
          message: 'Delete Category',
          child: _actionButton(
            icon: Icons.delete_outline_rounded,
            tooltipColor: Colors.red,
            isDelete: true,
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color tooltipColor,
    required VoidCallback onPressed,
    bool isDelete = false,
  }) {
    return Material(
      color: isDelete
          ? Colors.red.withOpacity(0.07)
          : AppColors.primary.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 20,
            color: tooltipColor,
          ),
        ),
      ),
    );
  }
}