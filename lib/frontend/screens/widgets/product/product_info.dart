import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductInfo extends StatelessWidget {
  final String productName;
  final double rating;
  final int reviewCount;
  final String brand;
  final String category;
  final bool inStock;

  const ProductInfo({
    super.key,
    required this.productName,
    required this.rating,
    required this.reviewCount,
    required this.brand,
    required this.category,
    required this.inStock,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Product Name
          Text(
            productName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          

          const SizedBox(height: 12),

          /// Rating
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 20,
              ),

              const SizedBox(width: 5),

              Text(
                rating.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 8),

              Text(
                "($reviewCount Reviews)",
                style: const TextStyle(
                  color: AppColors.textSoft,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Brand
          Row(
            children: [
              const Text(
                "Brand : ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(brand),
            ],
          ),

          const SizedBox(height: 8),

          /// Category
          Row(
            children: [
              const Text(
                "Category : ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(category),
            ],
          ),

          const SizedBox(height: 15),

          /// Stock
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: inStock ? Colors.green : Colors.red,
                size: 18,
              ),

              const SizedBox(width: 8),

              Text(
                inStock ? "In Stock" : "Out of Stock",
                style: TextStyle(
                  color: inStock ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}