import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

import 'package:shop_aura/frontend/screens/widgets/product/product_action_buttons.dart';
import 'package:shop_aura/frontend/screens/widgets/product/product_color_selector.dart';
import 'package:shop_aura/frontend/screens/widgets/product/product_description.dart';
import 'package:shop_aura/frontend/screens/widgets/product/product_image_gallery.dart';
import 'package:shop_aura/frontend/screens/widgets/product/product_info.dart';
import 'package:shop_aura/frontend/screens/widgets/product/product_price.dart';
import 'package:shop_aura/frontend/screens/widgets/product/product_size_selector.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedImage = 0;
  int selectedSize = 1;
  int selectedColor = 0;
  bool isFavorite = false;

  final List<String> images = [
    "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200",
    "https://images.unsplash.com/photo-1549298916-b41d501d3772?w=1200",
    "https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=1200",
  ];

  final List<String> sizes = [
    "6",
    "7",
    "8",
    "9",
    "10",
  ];

  final List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,

        centerTitle: true,

        title: const Text(
          "Product Details",
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color:
                  isFavorite ? Colors.red : AppColors.text,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            ProductImageGallery(
              images: images,
              selectedImage: selectedImage,
              onImageSelected: (index) {
                setState(() {
                  selectedImage = index;
                });
              },
            ),

            const SizedBox(height: 25),

            ProductInfo(
              productName: "Nike Air Max Running Shoes",
              rating: 4.8,
              reviewCount: 2458,
              brand: "Nike",
              category: "Footwear",
              inStock: true,
            ),

            const SizedBox(height: 25),

            ProductPrice(
              price: 2499,
              oldPrice: 3999,
              discount: 38,
            ),

            const SizedBox(height: 30),
                        ProductSizeSelector(
              sizes: sizes,
              selectedIndex: selectedSize,
              onSizeSelected: (index) {
                setState(() {
                  selectedSize = index;
                });
              },
            ),

            const SizedBox(height: 30),

            ProductColorSelector(
              colors: colors,
              selectedIndex: selectedColor,
              onColorSelected: (index) {
                setState(() {
                  selectedColor = index;
                });
              },
            ),

            const SizedBox(height: 30),

            ProductDescription(
              description:
                  "Experience premium comfort with the Nike Air Max Running Shoes. "
                  "Designed with breathable mesh, lightweight cushioning, and a durable rubber sole. "
                  "Perfect for running, gym workouts, daily walking, and casual wear. "
                  "Its modern design combines style and performance for all-day comfort.",
            ),

            const SizedBox(height: 35),

            ProductActionButtons(
              onAddToCart: () {
                // TODO: Add to Cart
              },
              onBuyNow: () {
                // TODO: Buy Now
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
            