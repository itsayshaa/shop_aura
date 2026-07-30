import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/services/wishlist_service.dart';
import 'package:shop_aura/frontend/client/screens/orders_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _handleDestinationSelected(BuildContext context, int index) {
    if (index == 3) {
      if (currentIndex == 3) return; // already on Orders, do nothing

      // Orders tab -> push OrdersScreen directly
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OrdersScreen()),
      );
      return;
    }
    onTap(index);
  }

  Widget _wishlistIcon({required bool selected}) {
    return ListenableBuilder(
      listenable: WishlistService.instance,
      builder: (context, _) {
        final count = WishlistService.instance.items.length;
        return Badge(
          isLabelVisible: count > 0,
          label: Text(
            count > 99 ? "99+" : "$count",
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.danger,
          alignment: Alignment.topRight,
          child: Icon(selected ? Icons.favorite : Icons.favorite_border),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 72,
      selectedIndex: currentIndex,
      onDestinationSelected: (index) => _handleDestinationSelected(context, index),
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primary.withOpacity(.12),
      elevation: 8,

      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Home",
        ),
        const NavigationDestination(
          icon: Icon(Icons.grid_view_outlined),
          selectedIcon: Icon(Icons.grid_view_rounded),
          label: "Categories",
        ),
        NavigationDestination(
          icon: _wishlistIcon(selected: false),
          selectedIcon: _wishlistIcon(selected: true),
          label: "Wishlist",
        ),
        const NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: "Orders",
        ),
      ],
    );
  }
}