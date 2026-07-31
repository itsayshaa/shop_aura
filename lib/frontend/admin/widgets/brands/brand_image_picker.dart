import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class BrandImagePicker extends StatelessWidget {
  final String title;
  final String? imagePath;

  const BrandImagePicker({
    super.key,
    required this.title,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        imagePath != null &&
        imagePath!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            height: 210,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.circular(14),
                    child: Image.network(
                      imagePath!,
                      fit: BoxFit.contain,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return _buildUploadContent();
                      },
                    ),
                  )
                : _buildUploadContent(),
          ),

          const SizedBox(height: 12),

          const Text(
            'Upload a clear brand logo. '
            'PNG, JPG, or WEBP formats are recommended.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadContent() {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: AppColors.primary
                .withOpacity(0.09),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.cloud_upload_outlined,
            size: 29,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 13),

        const Text(
          'Upload Brand Logo',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Click to choose an image',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}