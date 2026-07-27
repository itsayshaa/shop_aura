import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        "title": "Order Confirmed",
        "subtitle":
            "Your Nike Air Max order has been confirmed.",
        "icon": Icons.check_circle,
        "color": Colors.green,
        "time": "2 min ago",
      },
      {
        "title": "Flash Sale",
        "subtitle":
            "Up to 70% OFF on Electronics today.",
        "icon": Icons.local_offer,
        "color": Colors.orange,
        "time": "15 min ago",
      },
      {
        "title": "Wishlist",
        "subtitle":
            "An item in your wishlist is now on sale.",
        "icon": Icons.favorite,
        "color": Colors.red,
        "time": "1 hour ago",
      },
      {
        "title": "Order Shipped",
        "subtitle":
            "Your package is on the way.",
        "icon": Icons.local_shipping,
        "color": Colors.blue,
        "time": "Yesterday",
      },
      {
        "title": "New Collection",
        "subtitle":
            "Explore our latest fashion arrivals.",
        "icon": Icons.shopping_bag,
        "color": Colors.purple,
        "time": "2 days ago",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.background,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (_, index) {
          final item = notifications[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor:
                      (item["color"] as Color).withOpacity(.12),
                  child: Icon(
                    item["icon"] as IconData,
                    color: item["color"] as Color,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        item["subtitle"] as String,
                        style: const TextStyle(
                          color: AppColors.textSoft,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  item["time"] as String,
                  style: const TextStyle(
                    color: AppColors.textSoft,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}