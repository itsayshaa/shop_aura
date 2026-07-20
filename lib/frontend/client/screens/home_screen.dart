import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/client/widgets/home/product_card.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

import 'package:shop_aura/frontend/client/screens/category_screen.dart';

import 'package:shop_aura/frontend/client/widgets/bottom_nav_bar.dart';
import 'package:shop_aura/frontend/client/widgets/home/banner_slider.dart';
import 'package:shop_aura/frontend/client/widgets/home/category_section.dart';
import 'package:shop_aura/frontend/client/widgets/home/home_header.dart';
import 'package:shop_aura/frontend/client/widgets/home/search_bar_widget.dart';
import 'package:shop_aura/frontend/client/widgets/home/shop_category.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  int selectedCategory = 0;
  int currentIndex = 0;

  // Temporary Local Data
  // Later these will come from MongoDB

  final List<Map<String, dynamic>> categories = [
    {"title": "All", "icon": Icons.apps_rounded},
    {"title": "Electronics", "icon": Icons.laptop_mac_rounded},
    {"title": "Mobiles", "icon": Icons.smartphone_rounded},
    {"title": "Fashion", "icon": Icons.checkroom_rounded},
    {"title": "Footwear", "icon": Icons.hiking_rounded},
    {"title": "Beauty", "icon": Icons.spa_outlined},
    {"title": "Home & Kitchen", "icon": Icons.home_rounded},
    {"title": "Furniture", "icon": Icons.chair_alt_rounded},
    {"title": "Accessories", "icon": Icons.watch_outlined},
    {"title": "Gaming", "icon": Icons.sports_esports_rounded},
    {"title": "Sports", "icon": Icons.sports_basketball_rounded},
    {"title": "Books", "icon": Icons.menu_book_rounded},
    {"title": "Kids", "icon": Icons.child_care_rounded},
    {"title": "Bags", "icon": Icons.shopping_bag_outlined},
  ];

  final List<String> banners = [
    "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200",
    "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200",
    "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=1200",
  ];

  // final List<Map<String, String>> shopCategories = [
  //   {
  //     "title": "Shoes",
  //     "image":
  //         "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200",
  //   },
  //   {
  //     "title": "Watch",
  //     "image":
  //         "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200",
  //   },
  //   {
  //     "title": "Fashion",
  //     "image":
  //         "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=1200",
  //   },
  //   {
  //     "title": "Headphones",
  //     "image":
  //         "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=1200",
  //   },
  //   {
  //     "title": "Furniture",
  //     "image":
  //         "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=1200",
  //   },
  //   {
  //     "title": "Beauty",
  //     "image":
  //         "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=1200",
  //   },
  // ];
  final List<Map<String, dynamic>> products = [
    {
      "networkImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3eSGmhJubfc-dwgA7h0_E3CkzrDgrb47x0-LNHVfkkQ&s=10",
      "category": "Football",
      "name": "Lionel Messi",
      "rating": 9.9,
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
      "rating": 9.8,
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
      "rating": 9.7,
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
      "rating": 9.6,
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
      "rating": 9.4,
      "reviews": 995,
      "price": 499990,
      "oldPrice": 515000,
      "discount": 11,
    },
    {
      "networkImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4J8QZY7g4x7pPStH_NNk5HC4au6ajp_dUcdyVqdwZ4PbTLt7tnBo630I&s=10",
      "category": "Football",
      "name": "julián Álvarez",
      "rating": 9.7,
      "reviews": 998,
      "price": 235000,
      "oldPrice": 244900,
      "discount": 10,
    },
    {
      "networkImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTShBWL-C1QiPc_akwFXmrRaXvIWFMyXeksOCQiocLsIYx1Fz7BZXirKhE&s=10",
      "category": "Football",
      "name": "Emiliano Martinez.",
      "rating": 9.5,
      "reviews": 1001,
      "price": 275000,
      "oldPrice": 244900,
      "discount": 0,
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

void changeTab(int index) {
  setState(() {
    currentIndex = index;
  });

  if (index == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoryScreen(),
      ),
    );
  }

  if (index == 2) {
    // Wishlist Screen (later)
  }

  if (index == 3) {
    // Orders Screen (later)
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: changeTab,
      ),

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

              /// Top Categories
              CategorySection(
                categories: categories,
                selectedIndex: selectedCategory,
                onCategoryTap: selectCategory,
              ),

              const SizedBox(height: 16),

              /// Banner Slider
              BannerSlider(banners: banners),

              const SizedBox(height: 20),

              /// Shop Categories
              // ShopCategory(categories: shopCategories),

              const SizedBox(height: 10),

              BannerSlider(
                banners: banners,
              ),
              const SizedBox(height: 10,),
 ShopCategory(
              categories:[
                {
                  "title":"Shoes",
                  "image":"https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200"
                },{
                  "title":"Watch",
                  "image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200"
                },
                {
                  "title":"Watch",
                  "image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200"
                },
                {
                  "title":"Watch",
                  "image":"https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200"
                },
              ],
            ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
