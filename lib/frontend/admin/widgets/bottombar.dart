import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class AdminBottomNav extends StatelessWidget {
  const AdminBottomNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: Colors.white,
      indicatorColor: AppColors.accentSoft,
      height: 64,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.grid_view_rounded),
          selectedIcon: Icon(
            Icons.grid_view_rounded,
            color: AppColors.accent,
          ),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(
            Icons.inventory_2_rounded,
            color: AppColors.accent,
          ),
          label: 'Products',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(
            Icons.receipt_long_rounded,
            color: AppColors.accent,
          ),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline_rounded),
          selectedIcon: Icon(
            Icons.people_rounded,
            color: AppColors.accent,
          ),
          label: 'Customers',
        ),
        NavigationDestination(
          icon: Icon(Icons.more_horiz_rounded),
          selectedIcon: Icon(
            Icons.more_horiz_rounded,
            color: AppColors.primary,
          ),
          label: 'More',
        ),
      ],
    );
  }

}