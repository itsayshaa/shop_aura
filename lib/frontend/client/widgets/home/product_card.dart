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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Scale everything off the card's own width, not the screen width,
        // so this works correctly in a GridView, a ListView, half-width
        // layouts, tablets, foldables, etc. 160 is the "reference" card
        // width these sizes were originally tuned for.
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width / 2;
        final scale = (width / 160).clamp(0.8, 1.3);

        return Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18 * scale),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---------------- IMAGE ----------------
              AspectRatio(
                aspectRatio: 1.1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: const Color(0xffF7EEE1),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            size: 60 * scale,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      left: 12 * scale,
                      top: 12 * scale,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10 * scale,
                          vertical: 5 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8 * scale),
                        ),
                        child: Text(
                          "-$discount%",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12 * scale,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12 * scale,
                      top: 12 * scale,
                      child: CircleAvatar(
                        radius: 16 * scale,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 16 * scale,
                          icon: const Icon(Icons.favorite_border),
                          color: Colors.red,
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ---------------- DETAILS ----------------
              Padding(
                padding: EdgeInsets.fromLTRB(
                  12 * scale,
                  8 * scale,
                  12 * scale,
                  4 * scale,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10 * scale,
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(height: 2 * scale),

                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13 * scale,
                        height: 1.1,
                      ),
                    ),

                    SizedBox(height: 3 * scale),

                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 13 * scale,
                        ),
                        Text(
                          " $rating",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 11 * scale,
                          ),
                        ),
                        Text(
                          " ($reviews)",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10 * scale,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3 * scale),

                    Wrap(
                      spacing: 6 * scale,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "₹$price",
                          style: TextStyle(
                            fontSize: 15 * scale,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "₹$oldPrice",
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 11 * scale,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6 * scale),

                    SizedBox(
                      width: double.infinity,
                      height: 30 * scale,
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
                            borderRadius: BorderRadius.circular(10 * scale),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 14 * scale,
                              ),
                              SizedBox(width: 5 * scale),
                              Text(
                                "Add to Cart",
                                style: TextStyle(
                                  fontSize: 12 * scale,
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
            ],
          ),
        );
      },
    );
  }
}