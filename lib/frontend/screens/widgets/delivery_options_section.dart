import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class DeliveryOptionsSection extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const DeliveryOptionsSection({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      (
        title: "Standard Delivery",
        description: "Delivery in 3-5 business days",
        price: "Free",
        icon: Icons.local_shipping_outlined
      ),
      (
        title: "Express Delivery",
        description: "Delivery in 1-2 business days",
        price: "₹99.00",
        icon: Icons.bolt_rounded
      ),
    ];

    return Column(
      children: List.generate(options.length, (index) {
        final opt = options[index];
        final isSelected = selectedIndex == index;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            onTap: () => onChanged(index),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 1.5 : 1,
                ),
                color: isSelected ? AppColors.primary.withOpacity(0.04) : null,
              ),
              child: Row(
                children: [
                  Icon(
                    opt.icon,
                    color: isSelected ? AppColors.primary : AppColors.textSoft,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opt.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          opt.description,
                          style: TextStyle(
                            color: AppColors.textSoft,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    opt.price,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected ? AppColors.primary : AppColors.text,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    size: 20,
                    color: isSelected ? AppColors.primary : AppColors.textSoft,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
