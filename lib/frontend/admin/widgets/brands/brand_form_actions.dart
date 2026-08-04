import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class BrandFormActions extends StatelessWidget {
  final String saveText;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const BrandFormActions({
    super.key,
    required this.saveText,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.end,
      children: [
        OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textDark,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 17,
            ),
            side: BorderSide(
              color: Colors.grey.shade300,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: const Text(
            'Cancel',
          ),
        ),

        ElevatedButton.icon(
          onPressed: onSave,
          icon: const Icon(
            Icons.save_outlined,
            size: 20,
          ),
          label: Text(
            saveText,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 17,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}