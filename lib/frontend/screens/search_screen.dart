import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/services/product_service.dart';
import 'package:shop_aura/frontend/models/product_model.dart';
import 'package:shop_aura/frontend/client/screens/product_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();

  final ProductService _service = ProductService.instance;

  List<ProductModel> products = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    products = await _service.getProducts();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> search(String value) async {
    if (value.trim().isEmpty) {
      products = await _service.getProducts();
    } else {
      products = await _service.searchProducts(value);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Search products...",
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: search,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : products.isEmpty
              ? const Center(
                  child: Text(
                    "No Products Found",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    final product = products[index];

                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.all(10),

                        leading: Hero(
                          tag: product.id,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(12),
                            child: Image.network(
                              product.image,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        title: Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(product.category),
                            const SizedBox(height: 5),
                            Text(
                              "₹${product.price.toStringAsFixed(0)}",
                              style: const TextStyle(
                                color:
                                    AppColors.primary,
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductScreen(
                                productName:
                                    product.name,
                                category:
                                    product.category,
                                image: product.image,
                                price:
                                    product.price,
                                oldPrice:
                                    product.oldPrice,
                                rating:
                                    product.rating,
                                reviews:
                                    product.reviews,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}