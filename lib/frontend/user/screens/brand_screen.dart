import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/user/screens/product_list_screen.dart';

class BrandScreen extends StatelessWidget {
  const BrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brands = [
      {
        "name": "Nike",
        "image":
            "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200",
      },
      {
        "name": "Adidas",
        "image":
            "https://images.unsplash.com/photo-1549298916-b41d501d3772?w=1200",
      },
      {
        "name": "Puma",
        "image":
            "https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=1200",
      },
      {
        "name": "Sony",
        "image":
            "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=1200",
      },
      {
        "name": "Apple",
        "image":
            "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=1200",
      },
      {
        "name": "Samsung",
        "image":
            "https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=1200",
      },
      {
        "name": "Levis",
        "image":
            "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=1200",
      },
      {
        "name": "IKEA",
        "image":
            "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=1200",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Popular Brands",
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: brands.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: .9,
        ),
        itemBuilder: (_, index) {
          final brand = brands[index];

          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
          Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const ProductListScreen(
      category: "All",
    ),
  ),
);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(brand["image"]!),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    brand["name"]!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "View Products",
                    style: TextStyle(color: AppColors.textSoft),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
