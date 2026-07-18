import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/client/widgets/bottom_nav_bar.dart';
import 'package:shop_aura/frontend/client/widgets/home/banner_slider.dart';
import 'package:shop_aura/frontend/client/widgets/home/category_section.dart';
import 'package:shop_aura/frontend/client/widgets/home/home_header.dart';
import 'package:shop_aura/frontend/client/widgets/home/search_bar_widget.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/client/widgets/home/shop_category.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  int selectedCategory = 0;
  int currentIndex = 0;

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

    switch (index) {
      case 0:
        // Home
        break;

      case 1:
        // Categories
        break;

      case 2:
        // Wishlist
        break;

      case 3:
        // Cart
        break;
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

              const SizedBox(height: 10),

              SearchBarWidget(controller: searchController),

              const SizedBox(height: 14),

              CategorySection(
                categories: categories,
                selectedIndex: selectedCategory,
                onCategoryTap: selectCategory,
              ),

              const SizedBox(height: 10),

              BannerSlider(banners: banners),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 18),
                child:Text(
                  "Categories",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
                )
              ),
              ShopCategory(
                categories: [
                  {
                    "title": "Shoes",
                    "image":
                        "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200",
                  },
                  {
                    "title": "Watch",
                    "image":
                        "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200",
                  },
                  {
                    "title": "Watch",
                    "image":
                        "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200",
                  },
                  {
                    "title": "Watch",
                    "image":
                        "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200",
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
