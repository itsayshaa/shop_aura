import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class RelatedProducts extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const RelatedProducts({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            "Related Products",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 240,

            child: ListView.separated(
              scrollDirection: Axis.horizontal,

              itemCount: products.length,

              separatorBuilder: (_, __) =>
                  const SizedBox(width: 16),

              itemBuilder: (_, index) {

                final product = products[index];

                return Container(
                  width: 160,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),

                  child: Column(
                    children: [

                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                          child: Image.network(
                            product["image"],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Padding(
                        padding:
                            const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              product["name"],
                              maxLines: 2,
                              overflow:
                                  TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "₹${product["price"]}",
                              style: const TextStyle(
                                color:
                                    AppColors.primary,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}