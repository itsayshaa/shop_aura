import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/services/cart_service.dart';
import 'package:shop_aura/frontend/services/wishlist_service.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.primary,
        title: const Text(
          "My Wishlist",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListenableBuilder(
        listenable: WishlistService.instance,
        builder: (context, _) {
          final wishlist = WishlistService.instance;
          final items = wishlist.items;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 70,
                    color: AppColors.textSoft,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Your wishlist is empty",
                    style: TextStyle(color: AppColors.textSoft, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];

              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.image,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 70,
                          height: 70,
                          color: AppColors.secondarySoft,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSoft,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 13,
                              ),
                              Text(
                                " ${item.rating}",
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                " (${item.reviews})",
                                style: TextStyle(
                                  color: AppColors.textSoft,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                "₹${item.price}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "₹${item.oldPrice}",
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.textSoft,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Actions: move to cart / remove
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          tooltip: "Add to cart",
                          onPressed: () {
                            CartService.instance.addToCart(
                              image: item.image,
                              category: item.category,
                              name: item.name,
                              price: item.price,
                              oldPrice: item.oldPrice,
                            );

                            ScaffoldMessenger.of(
                              context,
                            ).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${item.name} added to cart"),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => wishlist.removeItem(index),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            size: 14,
                            color: AppColors.danger,
                          ),
                          label: Text(
                            "Remove",
                            style: TextStyle(
                              color: AppColors.danger,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}