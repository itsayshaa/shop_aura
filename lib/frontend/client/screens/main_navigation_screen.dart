import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'category_screen.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';

import 'package:shop_aura/frontend/client/screens/widgets/bottom_nav_bar.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  late int currentIndex;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;

    pages = const [
      HomeScreen(),
      // CategoryScreen(),
      WishlistScreen(),
      CartScreen(),
      OrdersScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}