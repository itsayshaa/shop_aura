import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ProductSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      value: value,
      activeColor: AppColors.primary,
      onChanged: onChanged,
    );
  }
}