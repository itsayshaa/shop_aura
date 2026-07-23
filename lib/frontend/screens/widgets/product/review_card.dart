import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const ReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              const CircleAvatar(
                radius: 22,
                child: Icon(Icons.person),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  review["name"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              Row(
                children: List.generate(
                  review["rating"],
                  (index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
              ),

            ],
          ),

          const SizedBox(height: 12),

          Text(
            review["comment"],
            style: const TextStyle(
              color: AppColors.textSoft,
              height: 1.5,
            ),
          ),

        ],
      ),
    );
  }
}