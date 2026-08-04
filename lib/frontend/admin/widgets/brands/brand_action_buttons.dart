import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class BrandActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BrandActionButtons({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: Icons.edit_outlined,
          iconColor: AppColors.primary,
          backgroundColor:
              AppColors.primary.withOpacity(0.08),
          tooltip: 'Edit Brand',
          onPressed: onEdit,
        ),

        const SizedBox(width: 8),

        _buildActionButton(
          icon: Icons.delete_outline_rounded,
          iconColor: Colors.red,
          backgroundColor:
              Colors.red.withOpacity(0.08),
          tooltip: 'Delete Brand',
          onPressed: onDelete,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: backgroundColor,
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
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}