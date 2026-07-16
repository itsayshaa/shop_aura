import 'package:flutter/material.dart';

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
  final TextEditingController searchController =
      TextEditingController();

  int selectedCategory = 0;
  int currentIndex = 0;

  // Temporary Local Data
  // Later these will come from MongoDB

  final List<Map<String, dynamic>> categories = [
    {
      "title": "All",
      "icon": Icons.apps_rounded,
    },
    {
      "title": "Electronics",
      "icon": Icons.laptop_mac_rounded,
    },
    {
      "title": "Mobiles",
      "icon": Icons.smartphone_rounded,
    },
    {
      "title": "Fashion",
      "icon": Icons.checkroom_rounded,
    },
    {
      "title": "Footwear",
      "icon": Icons.hiking_rounded,
    },
    {
      "title": "Beauty",
      "icon": Icons.spa_outlined,
    },
    {
      "title": "Home & Kitchen",
      "icon": Icons.home_rounded,
    },
    {
      "title": "Furniture",
      "icon": Icons.chair_alt_rounded,
    },
    {
      "title": "Accessories",
      "icon": Icons.watch_outlined,
    },
    {
      "title": "Gaming",
      "icon": Icons.sports_esports_rounded,
    },
    {
      "title": "Sports",
      "icon": Icons.sports_basketball_rounded,
    },
    {
      "title": "Books",
      "icon": Icons.menu_book_rounded,
    },
    {
      "title": "Kids",
      "icon": Icons.child_care_rounded,
    },
    {
      "title": "Bags",
      "icon": Icons.shopping_bag_outlined,
    },
  ];

  final List<String> banners = [
    "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200",
    "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200",
    "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=1200",
  ];

  final List<Map<String, String>> shopCategories = [
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
      "title": "Fashion",
      "image":
          "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=1200",
    },
    {
      "title": "Headphones",
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=1200",
    },
    {
      "title": "Furniture",
      "image":
          "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=1200",
    },
    {
      "title": "Beauty",
      "image":
          "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=1200",
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
    void changeTab(int index) async {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        setState(() {
          currentIndex = 0;
        });
        break;

      case 1:
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CategoryScreen(),
          ),
        );

        // Highlight Home again when returning
        setState(() {
          currentIndex = 0;
        });
        break;

      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wishlist page coming soon"),
          ),
        );
        break;

      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("My Orders page coming soon"),
          ),
        );
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

              /// Header
              const HomeHeader(),

              const SizedBox(height: 12),

              /// Search Bar
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
              BannerSlider(
                banners: banners,
              ),

              const SizedBox(height: 20),

              /// Shop Categories
              ShopCategory(
                categories: shopCategories,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}