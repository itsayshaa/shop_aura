import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_section_card.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductDynamicList extends StatelessWidget {
  final String title;
  final List<String> items;
  final String addText;
  final VoidCallback onAdd;
  final ValueChanged<String> onDelete;

  const ProductDynamicList({
    super.key,
    required this.title,
    required this.items,
    required this.addText,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ProductSectionCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (items.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: items.map((item) {
                return Chip(
                  label: Text(item),
                  deleteIcon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                  ),
                  onDeleted: () {
                    onDelete(item);
                  },
                );
              }).toList(),
            ),

          if (items.isNotEmpty)
            const SizedBox(height: 15),

          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: Text(addText),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}