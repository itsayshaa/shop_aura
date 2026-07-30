import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

class ReviewCard extends StatefulWidget {
  final String? userName;
  final String? review;
  final double rating;
  final String? date;

  const ReviewCard({
    super.key,
    this.userName,
    this.review,
    this.rating = 4.8,
    this.date,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              CircleAvatar(
                radius: 22,
                backgroundColor:
                    AppColors.primary.withOpacity(.1),
                child: Text(
                  (widget.userName ?? "A")[0]
                      .toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      widget.userName ??
                          "Ayisha Sherin",
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      widget.date ??
                          "2 days ago",
                      style: TextStyle(
                        color:
                            Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),

                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Row(
                  children: [

                    Text(
                      widget.rating
                          .toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 4),

                    const Icon(
                      Icons.star,
                      size: 14,
                      color: Colors.white,
                    ),

                  ],
                ),
              ),

            ],
          ),

          const SizedBox(height: 16),

          Text(
            widget.review ??
                "Excellent product. Premium quality, beautiful design, and worth every rupee. Delivery was fast and packaging was excellent.",
            style: const TextStyle(
              height: 1.6,
              fontSize: 15,
            ),
          ),

        ],
      ),
    );
  }
}