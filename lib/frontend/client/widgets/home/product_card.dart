import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String category;
  final String name;
  final double rating;
  final int reviews;
  final int price;
  final int oldPrice;
  final int discount;
  // final VoidCallback onCart;
  // final VoidCallback onWishlist;

  const ProductCard({
    super.key,
    required this.image,
    required this.category,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.oldPrice,
    required this.discount,
    // required this.onCart,
    // required this.onWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 4, // was 5 -> gives a bit more room to the text section below
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xffF7EEE1),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.network(
                      image,
                      fit: BoxFit.contain,
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported,
                          size: 60,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "-$discount%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border) ,
                        color: Colors.red,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            flex: 5, // was 4 -> more room for text/button so nothing overflows
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8, // reduced from 10
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10, // reduced from 11
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 2), // reduced from 4

                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13, // reduced from 14
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 13,
                      ),
                      Text(
                        " $rating",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        " ($reviews)",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2), // reduced from 4

                  Wrap(
                    spacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "₹$price",
                        style: const TextStyle(
                          fontSize: 15, // reduced from 16
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹$oldPrice",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 32, // reduced from 34
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2E2926),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
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
}