import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class UpiPaymentSection extends StatelessWidget {
  final TextEditingController upiCtrl;

  const UpiPaymentSection({
    super.key,
    required this.upiCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        TextFormField(
          controller: upiCtrl,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            labelText: "UPI ID (e.g. mobile@upi)",
            labelStyle: const TextStyle(color: AppColors.textSoft, fontSize: 13),
            prefixIcon: const Icon(Icons.alternate_email_rounded, size: 20, color: AppColors.textSoft),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.danger),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
            ),
          ),
          validator: (val) {
            if (val == null || val.trim().isEmpty) return "Enter UPI ID";
            if (!val.contains('@')) return "Enter a valid UPI ID (must contain @)";
            return null;
          },
        ),
      ],
    );
  }
}
