import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

import 'package:shop_aura/frontend/client/screens/widgets/home/home_header.dart';
import 'package:shop_aura/frontend/client/screens/widgets/home/search_bar_widget.dart';
import 'package:shop_aura/frontend/client/screens/widgets/home/category_section.dart';
import 'package:shop_aura/frontend/client/screens/widgets/home/banner_slider.dart';
import 'package:shop_aura/frontend/client/screens/widgets/home/shop_category.dart';
import 'package:shop_aura/frontend/client/screens/widgets/product/product_card.dart';
import 'package:shop_aura/frontend/models/product_model.dart';
import 'package:shop_aura/frontend/client/screens/product_screen.dart';
import 'package:shop_aura/frontend/utils/app_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  int selectedCategory = 0;

  final List<Map<String, dynamic>> products = [
    {
      "networkImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRv_dHYvtaa696TUVBiX1nfJ5SBZ7n1pk0YyH4ge5rj-w&s=10",
      "category": "Category",
      "name": "HEADPHONE",
      "rating": 4.5,
      "reviews": 103,
      "price": 2999,
      "oldPrice": 4999,
      "discount": 18,
    },
    {
      "networkImage":
          "https://png.pngtree.com/png-vector/20251224/ourmid/pngtree-minimal-plain-black-t-shirt-mockup-template-png-image_18327760.webp",
      "category": "T-shirt",
      "name": "Black t-shirt",
      "rating": 4.3,
      "reviews": 486,
      "price": 399,
      "oldPrice": 799 ,
      "discount": 50,
    },
    {
      "networkImage":
          "https://m.media-amazon.com/images/I/61qGik6SqeL._AC_UY1000_.jpg",
      "category": "Sports",
      "name": "Anza BHASMA",
      "rating": 4.4,
      "reviews": 67,
      "price": 999,
      "oldPrice": 1499,
      "discount": 15,
    },
    {
      "networkImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0J_JH0y5YjIdj8dje5ZrNLiz3cZ1FsVh6inP4ummmyg&s=10",
      "category": "Travel Bag",
      "name": "Troli",
      "rating": 4.2,
      "reviews": 246,
      "price": 4999,
      "oldPrice": 7999,
      "discount": 14,
    },
    {
      "networkImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTO8NtqoBk_gItxgM90YRPR4vTJ-Kb2OCtCXAQhbqD1Cg&s=10",
      "category": "Toys",
      "name": "Goorka 4*4",
      "rating": 4.6,
      "reviews": 318,
      "price": 8499,
      "oldPrice": 11500,
      "discount": 11,
    },
    {
      "networkImage":
          "https://in.tornado.store/cdn/shop/files/T26101-BFHH-1.webp?v=1771584649&width=600",
      "category": "Accessories",
      "name": "Watch",
      "rating": 4.7,
      "reviews": 99,
      "price": 6499,
      "oldPrice": 8499,
      "discount": 10,
    },
    {
      "networkImage":
          "https://m.media-amazon.com/images/I/31qKPlsxlnL.AC_SX250.jpg",
      "category": "Power Tools",
      "name": "CORDED Rotary Drill",
      "rating": 4.3,
      "reviews": 17,
      "price": 1952,
      "oldPrice": 3000,
      "discount": 35,
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void selectCategory(int index) {
    setState(() {
      selectedCategory = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),

              const SizedBox(height: 12),

              SearchBarWidget(controller: searchController),

              const SizedBox(height: 18),

              CategorySection(
                categories: AppData.homeCategories,
                selectedIndex: selectedCategory,
                onCategoryTap: selectCategory,
              ),

              const SizedBox(height: 18),

              BannerSlider(banners: AppData.banners),

              const SizedBox(height: 20),

              ShopCategory(categories: AppData.shopCategories),

              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: .56,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductScreen(
                            productName: product["name"],
                            category: product["category"],
                            image: product["networkImage"],
                            price: (product["price"] as int).toDouble(),
                            oldPrice: (product["oldPrice"] as int).toDouble(),
                            rating: (product["rating"] as num).toDouble(),
                            reviews: product["reviews"],
                          ),
                        ),
                      );
                    },
                    child: ProductCard(
                      product: ProductModel(
                        id: index.toString(),
                        name: product["name"],
                        brand: "Shop Aura",
                        category: product["category"],
                        image: product["networkImage"],
                        price: (product["price"] as num).toDouble(),
                        oldPrice: (product["oldPrice"] as num).toDouble(),
                        rating: (product["rating"] as num).toDouble(),
                        reviews: product["reviews"],
                        stock: 20,
                        discount: product["discount"],
                        isFavorite: false,
                        isFeatured: true,
                        isBestSeller: false,
                        isFlashSale: false,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductScreen(
                              productName: product["name"],
                              category: product["category"],
                              image: product["networkImage"],
                              price: (product["price"] as num).toDouble(),
                              oldPrice: (product["oldPrice"] as num).toDouble(),
                              rating: (product["rating"] as num).toDouble(),
                              reviews: product["reviews"],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
