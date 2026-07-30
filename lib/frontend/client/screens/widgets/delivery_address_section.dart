import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          ],
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return "Enter your full name";
            }
            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val.trim())) {
              return "Full name must contain only alphabets";
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: phoneCtrl,
          label: "Phone Number",
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return "Enter your phone number";
            }
            if (val.trim().length != 10 || !RegExp(r'^\d{10}$').hasMatch(val.trim())) {
              return "Enter a valid 10-digit phone number";
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: streetCtrl,
          label: "Address (Area and Street)",
          icon: Icons.home_outlined,
          maxLines: 2,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,#.\-\/]')),
          ],

          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return "Enter your street address";
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: cityCtrl,
                label: "City",
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Enter city";
                  }
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val.trim())) {
                    return "City must contain only alphabets";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: stateCtrl,
                label: "State",
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Enter state";
                  }
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val.trim())) {
                    return "State must contain only alphabets";
                  }
                  return null;
                },
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
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return "Enter PIN code";
            }
            if (!RegExp(r'^\d+$').hasMatch(val.trim())) {
              return "PIN code must contain only numbers";
            }
            if (val.trim().length < 5 || val.trim().length > 6) {
              return "Enter a valid PIN code (e.g. 5-6 digits)";
            }
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
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}