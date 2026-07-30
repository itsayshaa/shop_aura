import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/models/product_model.dart';
import 'package:shop_aura/frontend/providers/product_provider.dart';

import 'package:shop_aura/frontend/user/screens/widgets/product/product_grid.dart';
import 'package:shop_aura/frontend/user/screens/widgets/product/filter_bottom_sheet.dart';
import 'package:shop_aura/frontend/user/screens/widgets/product/sort_bottom_sheet.dart';

import 'product_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String category;

  const ProductListScreen({
    super.key,
    required this.category,
  });

  @override
  State<ProductListScreen> createState() =>
      _ProductListScreenState();
}

class _ProductListScreenState
    extends State<ProductListScreen> {

  final TextEditingController _searchController =
      TextEditingController();

  bool isGrid = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProductProvider>().loadProducts();
    });
  }

  Future<void> _refresh() async {
    await context.read<ProductProvider>().refresh();
  }

  void _openProduct(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductScreen(
          productName: product.name,
          category: product.category,
          image: product.image,
          price: product.price,
          oldPrice: product.oldPrice,
          rating: product.rating,
          reviews: product.reviews,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {

        List<ProductModel> products =
            provider.products.where((product) {

          return product.category
              .toLowerCase()
              .contains(
                widget.category.toLowerCase(),
              );

        }).toList();
                return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.background,
            centerTitle: true,
            title: Text(
              widget.category,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isGrid = !isGrid;
                  });
                },
                icon: Icon(
                  isGrid
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          body: RefreshIndicator(
            onRefresh: _refresh,

            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [


                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        provider.searchProducts(value);
                      },
                      decoration: InputDecoration(
                        hintText: "Search products...",
                        prefixIcon:
                            const Icon(Icons.search),

                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            provider.searchProducts("");
                          },
                        ),

                        filled: true,
                        fillColor: Colors.white,

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),


                    Row(
                      children: [

                        Text(
                          "${products.length} Products",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        IconButton(
                          onPressed: () {
                            FilterBottomSheet.show(
                              context,
                            );
                          },
                          icon: const Icon(
                            Icons.filter_alt_outlined,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            SortBottomSheet.show(
                              context,
                            );
                          },
                          icon: const Icon(
                            Icons.sort,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                                        if (provider.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 80),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (products.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 80,
                        ),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 90,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "No Products Found",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Try another search or category",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 350,
                        ),
                        child: ProductGrid(
                          key: ValueKey(products.length),
                          products: products,
                          onProductTap: (product) {
                            _openProduct(product);
                          },
                          onFavourite: (product) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${product.name} added to Wishlist",
                                ),
                                duration: const Duration(
                                  seconds: 1,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 30),
                                      ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}