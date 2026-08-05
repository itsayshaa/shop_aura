import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class CategoryImagePicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onPickImage;
  final VoidCallback? onRemoveImage;

  const CategoryImagePicker({
    super.key,
    required this.imagePath,
    required this.onPickImage,
    this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        imagePath != null && imagePath!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onPickImage,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            height: 210,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasImage
                    ? AppColors.primary.withOpacity(0.35)
                    : Colors.grey.shade300,
                width: hasImage ? 1.5 : 1,
              ),
            ),
            child: hasImage
                ? _buildImagePreview()
                : _buildUploadPlaceholder(),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: Text(
                hasImage
                    ? 'Category image selected'
                    : 'No category image selected',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),
            ),

            if (hasImage && onRemoveImage != null)
              TextButton.icon(
                onPressed: onRemoveImage,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: Colors.red,
                ),
                label: const Text(
                  'Remove',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 3),

        const Text(
          'Supported formats: JPG, PNG and WEBP',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          size: 48,
          color: AppColors.primary,
        ),

        SizedBox(height: 13),

        Text(
          'Click to upload category image',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),

        SizedBox(height: 6),

        Text(
          'Upload a clear image for this category',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return _buildImageError();
            },
          ),

          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 17,
                  ),

                  SizedBox(width: 5),

                  Text(
                    'Selected',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageError() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.broken_image_outlined,
          size: 45,
          color: AppColors.textGrey,
        ),

        SizedBox(height: 10),

        Text(
          'Unable to load image',
          style: TextStyle(
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}