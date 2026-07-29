import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductActionButtons extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductActionButtons({
    super.key,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onAddToCart,
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text("Add to Cart"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: ElevatedButton(
              onPressed: onBuyNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
                child: const Text(
                  "Buy Now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}