import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_aura/backend/database/mongo_service.dart';
import 'package:shop_aura/backend/models/client/categoryModel.dart';
import 'package:shop_aura/frontend/admin/dashboard.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

import 'package:shop_aura/frontend/client/screens/widgets/home/home_header.dart';
import 'package:shop_aura/frontend/client/screens/widgets/home/search_bar_widget.dart';
import 'package:shop_aura/frontend/client/screens/widgets/home/category_section.dart';
import 'package:shop_aura/frontend/client/screens/widgets/home/banner_slider.dart';
import 'package:shop_aura/frontend/client/screens/widgets/home/shop_category.dart';
import 'package:shop_aura/frontend/client/screens/widgets/product/product_card.dart';
import 'package:shop_aura/frontend/client/screens/product_screen.dart';
import 'package:shop_aura/frontend/utils/app_data.dart';
import 'package:shop_aura/backend/models/client/productModel.dart';

import 'package:shop_aura/frontend/services/product_service.dart';
import 'package:shop_aura/frontend/services/category_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  int selectedCategory = 0;
  List<ProductsModel> products = [];

  final ProductService service = ProductService();
  Future<void> findAdmin() async{
    if(!mounted) return;
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString("user_role");
      print("admin $role");
      if(role == "admin"){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => AdminApp()
            ),
            (route) => false
        );
        return;
      }
  }
  @override
  void initState() {
    super.initState();
    findAdmin();
    loadData();
  }

List<CategoryModel> categories = [];
Future<void> loadData() async {
  try{
  final response =await CategoryService().getCategories();
  print("Load Data: $response");
  setState(() {
    categories = response;
    loading = false;
  });
}catch(e){
  print("category error: $e");
}
}

  bool loading = true;
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

@override
Widget build(BuildContext context) {

List<ProductsModel> filteredProducts = products;



  return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),

              const SizedBox(height: 12),

              SearchBarWidget(controller: searchController),

              const SizedBox(height: 18),

              CategorySection(
                categories: categories,
                selectedIndex: selectedCategory,
                onCategoryTap: selectCategory,
              ),

              const SizedBox(height: 18),

              BannerSlider(banners: AppData.banners),

              const SizedBox(height: 20),

              ShopCategory(categories: categories),

              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: .56,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];

                  return ProductCard(
                    product: ProductsModel(
                      isActive: product.isActive,
                      categoryName: product.categoryName,
                      id: product.id,
                      categoryId: product.categoryId,
                      productName: product.productName,
                      brand: product.brand,
                      description: product.description,
                      productImage: product.productImage,
                      weight: product.weight,
                      size: product.size,
                      color: product.color,
                      status: product.status,
                      price: product.price,
                      rating: product.rating,
                      reviews: product.reviews,
                      stock: product.stock,
                      discountPrice: product.discountPrice,
                      createdAt: product.createdAt,
                      updatedAt: product.updatedAt,
                      isTrending: product.isTrending,
                      isDeleted: product.isDeleted,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductScreen(
                            productId: product.id?.toHexString() ?? "",
                            productName: product.productName,
                            category: product.categoryName,
                            image: product.productImage.isNotEmpty
                                ? product.productImage.first
                                : "",
                            price: product.price,
                            oldPrice: product.discountPrice,
                            rating: product.rating,
                            reviews: product.reviews,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
