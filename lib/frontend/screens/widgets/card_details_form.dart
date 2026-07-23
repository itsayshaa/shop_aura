import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class CardDetailsForm extends StatelessWidget {
  final TextEditingController numberCtrl;
  final TextEditingController nameCtrl;
  final TextEditingController expiryCtrl;
  final TextEditingController cvvCtrl;

  const CardDetailsForm({
    super.key,
    required this.numberCtrl,
    required this.nameCtrl,
    required this.expiryCtrl,
    required this.cvvCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _buildTextField(
          controller: numberCtrl,
          label: "Card Number",
          icon: Icons.credit_card_rounded,
          keyboardType: TextInputType.number,
          validator: (val) {
            if (val == null || val.trim().isEmpty) return "Enter card number";
            if (val.replaceAll(' ', '').length < 16) return "Enter valid 16-digit card number";
            return null;
          },
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: nameCtrl,
          label: "Cardholder Name",
          icon: Icons.person_outline_rounded,
          validator: (val) => val == null || val.trim().isEmpty ? "Enter cardholder name" : null,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: expiryCtrl,
                label: "Expiry Date (MM/YY)",
                icon: Icons.calendar_today_outlined,
                keyboardType: TextInputType.datetime,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return "Enter expiry";
                  if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(val)) {
                    return "Use MM/YY format";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: cvvCtrl,
                label: "CVV",
                icon: Icons.lock_outline_rounded,
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return "Enter CVV";
                  if (val.trim().length < 3) return "Enter valid CVV";
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSoft, fontSize: 13),
        prefixIcon: Icon(icon, size: 20, color: AppColors.textSoft),
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
    );
  }
}
