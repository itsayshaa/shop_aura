import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class CategoryFormActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String saveButtonText;
  final bool isLoading;

  const CategoryFormActions({
    super.key,
    required this.onCancel,
    required this.onSave,
    this.saveButtonText = 'Save Category',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 550;

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: isLoading ? null : onSave,
                icon: isLoading
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_rounded),
                label: Text(
                  isLoading ? 'Saving...' : saveButtonText,
                ),
                style: _saveButtonStyle(),
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: isLoading ? null : onCancel,
                style: _cancelButtonStyle(),
                child: const Text('Cancel'),
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: isLoading ? null : onCancel,
              style: _cancelButtonStyle(),
              child: const Text('Cancel'),
            ),

            const SizedBox(width: 14),

            ElevatedButton.icon(
              onPressed: isLoading ? null : onSave,
              icon: isLoading
                  ? const SizedBox(
                      width: 19,
                      height: 19,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_rounded),
              label: Text(
                isLoading ? 'Saving...' : saveButtonText,
              ),
              style: _saveButtonStyle(),
            ),
          ],
        );
      },
    );
  }

  ButtonStyle _saveButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      disabledBackgroundColor: AppColors.primary.withOpacity(0.55),
      disabledForegroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 17,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  ButtonStyle _cancelButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.textDark,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 17,
      ),
      side: BorderSide(
        color: Colors.grey.shade300,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}