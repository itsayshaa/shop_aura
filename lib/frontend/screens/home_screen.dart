import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

import 'package:shop_aura/frontend/client/widgets/home/home_header.dart';
import 'package:shop_aura/frontend/client/widgets/home/search_bar_widget.dart';
import 'package:shop_aura/frontend/client/widgets/home/category_section.dart';
import 'package:shop_aura/frontend/client/widgets/home/banner_slider.dart';
import 'package:shop_aura/frontend/client/widgets/home/shop_category.dart';
import 'package:shop_aura/frontend/client/widgets/product/product_card.dart';
import 'package:shop_aura/frontend/models/product_model.dart';
import 'package:shop_aura/frontend/client/screens/product_screen.dart';
import 'package:shop_aura/frontend/utils/app_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController =
      TextEditingController();

  int selectedCategory = 0;

  final List<Map<String, dynamic>> products = [
    {
      "networkImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3eSGmhJubfc-dwgA7h0_E3CkzrDgrb47x0-LNHVfkkQ&s=10",
      "category": "Football",
      "name": "Lionel Messi",
      "rating": 4.9,
      "reviews": 1000,
      "price": 899990,
      "oldPrice": 950000,
      "discount": 11,
    },
    {
      "networkImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4mfqqLzhMIYYm7z6BhDh_XUoWpweK21fVYkK4V9iaISzWYKbj0lPJNdW5&s=10",
      "category": "Football",
      "name": "Enzo Fernandez",
      "rating": 4.8,
      "reviews": 999,
      "price": 799990,
      "oldPrice": 850000,
      "discount": 12,
    },
    {
      "networkImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbkEHxqrYqL_GoAe5OaddaqKhoj6GmWI9ZLAruaJwFqZcxQWX5ZW-thPys&s=10",
      "category": "Football",
      "name": "Rodrigo De Paul",
      "rating": 4.7,
      "reviews": 998,
      "price": 699990,
      "oldPrice": 775000,
      "discount": 15,
    },
    {
      "networkImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTJc4Ms3E6LWmYQ-r3uki1A8yO8qR3I-bul3180JRJOaKeZ38rhOr9NlrY&s=10",
      "category": "Football",
      "name": "Leandro Paredes",
      "rating": 4.6,
      "reviews": 997,
      "price": 599990,
      "oldPrice": 650000,
      "discount": 14,
    },
    {
      "networkImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSGy4ZDWnsFKlM7HwdOji9ZOOONixFsvidXlFGunNlCeMhVOpqkGQQMho&s=10",
      "category": "Football",
      "name": "Lisandro Martinez",
      "rating": 4.5,
      "reviews": 995,
      "price": 499990,
      "oldPrice": 515000,
      "discount": 11,
    },
    {
      "networkImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4J8QZY7g4x7pPStH_NNk5HC4au6ajp_dUcdyVqdwZ4PbTLt7tnBo630I&s=10",
      "category": "Football",
      "name": "Julian Alvarez",
      "rating": 4.8,
      "reviews": 998,
      "price": 235000,
      "oldPrice": 244900,
      "discount": 10,
    },
    {
      "networkImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTShBWL-C1QiPc_akwFXmrRaXvIWFMyXeksOCQiocLsIYx1Fz7BZXirKhE&s=10",
      "category": "Football",
      "name": "Emiliano Martinez",
      "rating": 4.7,
      "reviews": 1001,
      "price": 275000,
      "oldPrice": 295000,
      "discount": 8,
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

              SearchBarWidget(
                controller: searchController,
              ),

              const SizedBox(height: 18),

              CategorySection(
                categories: AppData.homeCategories,
                selectedIndex: selectedCategory,
                onCategoryTap: selectCategory,
              ),

              const SizedBox(height: 18),

              BannerSlider(
                banners: AppData.banners,
              ),

              const SizedBox(height: 20),

              ShopCategory(
                categories: AppData.shopCategories,
              ),

              const SizedBox(height: 20),
                            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                itemCount: products.length,
                gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
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
                            price: (product["price"] as int)
                                .toDouble(),
                            oldPrice:
                                (product["oldPrice"] as int)
                                    .toDouble(),
                            rating:
                                (product["rating"] as num)
                                    .toDouble(),
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