import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/widgets/products/product_dropdown_field.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_section_card.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_text_field.dart';

class ProductMeasurementSection extends StatelessWidget {
  final String selectedType;
  final String selectedUnit;
  final TextEditingController valueController;

  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onUnitChanged;

  const ProductMeasurementSection({
    super.key,
    required this.selectedType,
    required this.selectedUnit,
    required this.valueController,
    required this.onTypeChanged,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ProductSectionCard(
      title: 'Product Measurement',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          final width = isMobile
              ? double.infinity
              : (constraints.maxWidth - 32) / 3;

          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ProductDropdownField(
                label: 'Measurement Type',
                value: selectedType,
                items: const [
                  'Weight',
                  'Length',
                  'Width',
                  'Height',
                  'Volume',
                ],
                width: width,
                onChanged: onTypeChanged,
              ),

              ProductTextField(
                controller: valueController,
                label: 'Measurement Value',
                hint: 'Enter value',
                width: width,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),

              ProductDropdownField(
                label: 'Unit',
                value: selectedUnit,
                items: const [
                  'g',
                  'kg',
                  'cm',
                  'm',
                  'mm',
                  'ml',
                  'L',
                ],
                width: width,
                onChanged: onUnitChanged,
              ),
            ],
          );
        },
      ),
    );
  }
}