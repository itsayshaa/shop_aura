import 'package:flutter/material.dart';

class CategoryBanner extends StatefulWidget {
  final VoidCallback? onShopNow;

  const CategoryBanner({
    super.key,
    this.onShopNow,
  });

  @override
  State<CategoryBanner> createState() => _CategoryBannerState();
}

class _CategoryBannerState extends State<CategoryBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.03,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        height: 290,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Color(0xff2E2926),
              Color(0xff4A403A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [

              Positioned(
                right: -25,
                top: -20,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                right: -40,
                bottom: -45,
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: [

                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius:
                                  BorderRadius.circular(30),
                            ),
                            child: const Text(
                              "MEGA SALE",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            "Discover\nAmazing Deals",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Up to 70% OFF on top brands",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.85),
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 18),

                          ElevatedButton(
                            onPressed: widget.onShopNow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor:
                                  const Color(0xff2E2926),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(30),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 12,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Shop Now",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 4,
                      child: Hero(
                        tag: "category_banner",
                        child: Image.network(
                          "https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800",
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.shopping_bag,
                              color: Colors.white,
                              size: 90,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}