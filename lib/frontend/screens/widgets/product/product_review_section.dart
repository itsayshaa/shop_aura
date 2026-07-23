import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/screens/widgets/product/review_card.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductReviewSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const ProductReviewSection({
    super.key,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [

              Text(
                "Customer Reviews",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),

              Text(
                "See All",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),

            ],
          ),

          const SizedBox(height: 20),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            itemBuilder: (_, index) {
              return ReviewCard(
                review: reviews[index],
              );
            },
          ),

        ],
      ),
    );
  }
}