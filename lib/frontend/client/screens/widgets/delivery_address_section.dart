import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class DeliveryAddressSection extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController streetCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController zipCtrl;
  final TextEditingController stateCtrl;

  const DeliveryAddressSection({
    super.key,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.streetCtrl,
    required this.cityCtrl,
    required this.zipCtrl,
    required this.stateCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: nameCtrl,
          label: "Full Name",
          icon: Icons.person_outline,
          validator: (val) => val == null || val.trim().isEmpty ? "Enter your full name" : null,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: phoneCtrl,
          label: "Phone Number",
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (val) {
            if (val == null || val.trim().isEmpty) return "Enter your phone number";
            if (val.trim().length < 10) return "Enter a valid 10-digit phone number";
            return null;
          },
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: streetCtrl,
          label: "Address (Area and Street)",
          icon: Icons.home_outlined,
          maxLines: 2,
          validator: (val) => val == null || val.trim().isEmpty ? "Enter your street address" : null,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: cityCtrl,
                label: "City",
                validator: (val) => val == null || val.trim().isEmpty ? "City" : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: stateCtrl,
                label: "State",
                validator: (val) => val == null || val.trim().isEmpty ? "State" : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: zipCtrl,
          label: "PIN Code / Postal Code",
          icon: Icons.pin_drop_outlined,
          keyboardType: TextInputType.number,
          validator: (val) {
            if (val == null || val.trim().isEmpty) return "Enter PIN code";
            if (val.trim().length < 5) return "Enter valid PIN code";
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSoft, fontSize: 13),
        prefixIcon: icon != null ? Icon(icon, size: 20, color: AppColors.textSoft) : null,
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
