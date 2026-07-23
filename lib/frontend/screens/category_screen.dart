import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

import 'package:shop_aura/frontend/screens/widgets/home/category_header.dart';
import 'package:shop_aura/frontend/screens/widgets/home/category_chip.dart';
import 'package:shop_aura/frontend/screens/widgets/home/category_product_card.dart';

import 'package:shop_aura/frontend/screens/product_screen.dart';
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int selectedCategory = 0;

  final List<String> categories = [
    "All",
    "Fashion",
    "Electronics",
    "Shoes",
    "Beauty",
    "Furniture",
    "Sports",
    "Books",
    "Toys",
  ];

  final List<Map<String, dynamic>> products = [
    {
      "name": "Running Shoes",
      "description": "Comfortable sports shoes",
      "price": 2499,
      "unit": "Pair",
      "category": "Shoes",
      "image":
          "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600",
    },
    {
      "name": "Wireless Headphones",
      "description": "Premium sound quality",
      "price": 4999,
      "unit": "Piece",
      "category": "Electronics",
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600",
    },
    {
      "name": "Wooden Chair",
      "description": "Modern living room chair",
      "price": 3299,
      "unit": "Piece",
      "category": "Furniture",
      "image":
          "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=600",
    },
    {
      "name": "Face Cream",
      "description": "Natural skin care",
      "price": 699,
      "unit": "Piece",
      "category": "Beauty",
      "image":
          "https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=600",
    },
    {
      "name": "Men T-Shirt",
      "description": "100% Cotton",
      "price": 999,
      "unit": "Piece",
      "category": "Fashion",
      "image":
          "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600",
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    if (selectedCategory == 0) {
      return products;
    }

    return products
        .where(
          (item) =>
              item["category"] == categories[selectedCategory],
        )
        .toList();
  }

  Future<void> refresh() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: RefreshIndicator(
        color: AppColors.primary,

        onRefresh: refresh,

        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [
            SliverToBoxAdapter(
              child: CategoryHeader(
                onSearch: () {},
              ),
            ),

            SliverToBoxAdapter(
              child: const SizedBox(height: 20),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,

                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  scrollDirection: Axis.horizontal,

                  itemCount: categories.length,

                  itemBuilder: (context, index) {
                    return CategoryChip(
                      title: categories[index],

                      isSelected:
                          selectedCategory == index,

                      onTap: () {
                        setState(() {
                          selectedCategory = index;
                        });
                      },
                    );
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: const SizedBox(height: 22),
            ),
                        SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: filteredProducts.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.category_outlined,
                              size: 70,
                              color: AppColors.textSoft,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "No Products Found",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Try another category.",
                              style: TextStyle(
                                color: AppColors.textSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = filteredProducts[index];

                         return Padding(
  padding: const EdgeInsets.only(bottom: 18),
  child: CategoryProductCard(
    imageUrl: product["image"],
    name: product["name"],
    description: product["description"],
    price: product["price"].toDouble(),
    unit: product["unit"],
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ProductScreen(),
        ),
      );
    },
  ),
);
                        },
                        childCount: filteredProducts.length,
                      ),
                    ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }
}