import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_section_card.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductImageUpload extends StatelessWidget {
  final VoidCallback onTap;

  const ProductImageUpload({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProductSectionCard(
      title: 'Product Images',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 42,
                color: AppColors.primary,
              ),
              SizedBox(height: 10),
              Text(
                'Click to upload product images',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'PNG, JPG or WEBP',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}