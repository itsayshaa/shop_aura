import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_aura/frontend/models/category_model.dart';
import 'package:shop_aura/frontend/providers/category_provider.dart';

import 'package:shop_aura/frontend/client/screens/widgets/category/category_banner.dart';
import 'package:shop_aura/frontend/client/screens/widgets/category/category_card.dart';
import 'package:shop_aura/frontend/client/screens/widgets/category/category_grid.dart';
import 'package:shop_aura/frontend/client/screens/widgets/category/category_search_bar.dart';
import 'package:shop_aura/frontend/client/screens/widgets/category/featured_collection.dart';
import 'package:shop_aura/frontend/client/screens/widgets/category/brand_card.dart';
import 'package:shop_aura/frontend/client/screens/widgets/category/section_title.dart';

import 'product_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CategoryProvider>().loadCategories();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openProducts(CategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductListScreen(category: category.name),
      ),
    );
  }

  List<Map<String, dynamic>> _dummyProducts(String category) {
    return [
      {
        "name": "$category Product 1",
        "price": 999,
        "oldPrice": 1299,
        "rating": 4.8,
        "discount": 25,
        "image":
            "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800",
      },
      {
        "name": "$category Product 2",
        "price": 1499,
        "oldPrice": 1899,
        "rating": 4.5,
        "discount": 20,
        "image":
            "https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800",
      },
      {
        "name": "$category Product 3",
        "price": 799,
        "oldPrice": 999,
        "rating": 4.2,
        "discount": 15,
        "image":
            "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=800",
      },
      {
        "name": "$category Product 4",
        "price": 2499,
        "oldPrice": 2999,
        "rating": 4.9,
        "discount": 30,
        "image":
            "https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xffF7F7F7),

          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: false,
            title: const Text(
              "Categories",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, color: Colors.black),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, color: Colors.black),
              ),
            ],
          ),

          body: RefreshIndicator(
            onRefresh: provider.refresh,

            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  CategorySearchBar(
                    controller: _searchController,

                    onChanged: (value) {
                      provider.searchCategory(value);
                    },

                    onFilterTap: () {},
                  ),

                  const SizedBox(height: 10),

                  CategoryBanner(onShopNow: () {}),

                  const SizedBox(height: 10),
                  const SectionTitle(
                    title: "Featured Collections",
                    subtitle: "Best shopping collections for you",
                  ),

                  SizedBox(
                    height: 280,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        FeaturedCollection(
                          title: "New Arrivals",
                          subtitle: "JUST IN",
                          image:
                              "https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800",
                          color: Colors.deepPurple,
                          onTap: () {},
                        ),

                        FeaturedCollection(
                          title: "Best Sellers",
                          subtitle: "TRENDING",
                          image:
                              "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800",
                          color: Colors.orange,
                          onTap: () {},
                        ),

                        FeaturedCollection(
                          title: "Premium Picks",
                          subtitle: "TOP",
                          image:
                              "https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=800",
                          color: Colors.blue,
                          onTap: () {},
                        ),

                        FeaturedCollection(
                          title: "Flash Deals",
                          subtitle: "LIMITED",
                          image:
                              "https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800",
                          color: Colors.red,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SectionTitle(
                    title: "Popular Brands",
                    subtitle: "Official stores",
                    onSeeAll: () {},
                  ),

                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: provider.popularBrands.length,
                      itemBuilder: (context, index) {
                        return BrandCard(
                          brandName: provider.popularBrands[index],
                          onTap: () {},
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  SectionTitle(
                    title: "Shop by Category",
                    subtitle:
                        "${provider.searchResults.length} Categories Available",
                    onSeeAll: () {},
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),

                    child: provider.isLoading
                        ? const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : CategoryGrid(
                            categories: provider.searchResults,
                            isLoading: false,
                            onCategoryTap: (category) {
                              _openProducts(category);
                            },
                          ),
                  ),

                  const SizedBox(height: 30),

                  if (provider.featuredCategories.isNotEmpty) ...[
                    const SectionTitle(
                      title: "Featured Categories",
                      subtitle: "Recommended for you",
                    ),

                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.featuredCategories.length,
                        itemBuilder: (context, index) {
                          final category = provider.featuredCategories[index];

                          return SizedBox(
                            width: 220,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: CategoryCard(
                                category: category,
                                onTap: () {
                                  _openProducts(category);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],

                  if (provider.hasError)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          provider.error,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
