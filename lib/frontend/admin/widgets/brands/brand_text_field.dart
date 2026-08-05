import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class BrandTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final int maxLines;

  const BrandTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          maxLines: maxLines,

          textInputAction: maxLines > 1
              ? TextInputAction.newline
              : TextInputAction.next,

          decoration: InputDecoration(
            hintText: hintText,

            hintStyle: const TextStyle(
              fontSize: 14,
              color: AppColors.textGrey,
            ),

            filled: true,

            fillColor:
                const Color(0xFFF9F9FA),

            contentPadding:
                EdgeInsets.symmetric(
              horizontal: 16,
              vertical:
                  maxLines > 1
                      ? 15
                      : 17,
            ),

            border:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                12,
              ),

              borderSide:
                  BorderSide(
                color: Colors
                    .grey
                    .shade200,
              ),
            ),

            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                12,
              ),

              borderSide:
                  BorderSide(
                color: Colors
                    .grey
                    .shade200,
              ),
            ),

            focusedBorder:
                const OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(
                Radius.circular(
                  12,
                ),
              ),

              borderSide:
                  BorderSide(
                color:
                    AppColors.primary,
                width: 1.5,
              ),
            ),

            errorBorder:
                const OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(
                Radius.circular(
                  12,
                ),
              ),

              borderSide:
                  BorderSide(
                color: Colors.red,
              ),
            ),

            focusedErrorBorder:
                const OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(
                Radius.circular(
                  12,
                ),
              ),

              borderSide:
                  BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}