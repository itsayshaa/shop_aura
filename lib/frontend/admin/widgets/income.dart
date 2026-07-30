import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final List<Map<String, dynamic>> items = [
    {
      "title": "Products",
      "count": "120",
      "icon": Icons.inventory_2_outlined,
      "color": Colors.blue,
    },
    {
      "title": "Orders",
      "count": "56",
      "icon": Icons.shopping_cart_outlined,
      "color": Colors.orange,
    },
    {
      "title": "Customers",
      "count": "340",
      "icon": Icons.people_outline,
      "color": Colors.green,
    },
    {
      "title": "Revenue",
      "count": "₹85,000",
      "icon": Icons.currency_rupee,
      "color": Colors.purple,
    },
    {
      "title": "Categories",
      "count": "18",
      "icon": Icons.category_outlined,
      "color": Colors.red,
    },
    {
      "title": "Reviews",
      "count": "250",
      "icon": Icons.star_outline,
      "color": Colors.amber,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;

        if (constraints.maxWidth >= 1200) {
          crossAxisCount = 4; // Desktop
        } else if (constraints.maxWidth >= 800) {
          crossAxisCount = 3; // Tablet
        } else {
          crossAxisCount = 2; // Mobile
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor:
                        (item["color"] as Color).withOpacity(0.15),
                    child: Icon(
                      item["icon"] as IconData,
                      color: item["color"] as Color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item["count"] as String,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item["title"] as String,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}