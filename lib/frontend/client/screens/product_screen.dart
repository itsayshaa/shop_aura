import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/client/screens/widgets/product/review_card.dart';
import 'package:shop_aura/frontend/services/cart_service.dart';
import 'package:shop_aura/frontend/services/wishlist_service.dart';
import 'package:shop_aura/frontend/client/screens/wishlist_screen.dart';
import 'package:shop_aura/main.dart';
import 'package:http/http.dart' as http;




class ProductScreen extends StatefulWidget {
  final String productName;
  final String category;
  final String image;
  final String productId;
  final double price;
  final double oldPrice;
  final double rating;

  final int reviews;

  const ProductScreen({
    super.key,
    required this.productName,
    required this.productId,
    required this.category,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviews,
  });

  @override
  State<ProductScreen> createState() =>
      _ProductScreenState();
}
String? get baseUrl => Apiconfig.baseUrl;
Future<void> getProduct()async{
  try{
    final response = await http.get(
      Uri.parse("$baseUrl/product"),
      headers:{"Content-Type":"application/json"}
    );

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
    }
  }catch(e){
    print(e);
  }
}
class _ProductScreenState
    extends State<ProductScreen> {

  int selectedImage = 0;

  int quantity = 1;

  int selectedColor = 0;

  int selectedSize = 1;

  bool favourite = false;

  final List<String> images = [];

  final List<Color> colors = const [
    Colors.black,
    Colors.blue,
    Colors.red,
    Colors.green,
  ];

  final List<String> sizes = [
    "S",
    "M",
    "L",
    "XL",
  ];


String userId = "";


Future<void> getUserId()async{
  final prefs = await SharedPreferences.getInstance();
  final userid = prefs.getString("userId") ?? "";
  // if(userid.isEmpty){
  //  if(!mounted) return;
  //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
  //  return;
  // }

  setState(() {
    userId = userid;
  });
  print(userid);
}
  @override
  void initState() {
    super.initState();
    favourite = WishlistService.instance.isWishlisted(widget.productName);

    images.addAll([
      widget.image,
      widget.image,
      widget.image,
      widget.image,
    ]);
    getUserId();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: const BoxDecoration(
            color: Colors.white,
          ),

          child: Row(
            children: [

              // Expanded(
              //   child: OutlinedButton(
              //     onPressed: () {
              //       CartService.instance.addToCart(
              //         image: widget.image,
              //         category: widget.category,
              //         name: widget.productName,
              //         price: widget.price.toInt(),
              //         oldPrice: widget.oldPrice.toInt(),
              //       );
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (_) => const PaymentScreen(),
              //         ),
              //       );
              //     },
              //     child: const Text(
              //       "Buy Now",
              //     ),
              //   ),
              // ),

              const SizedBox(width: 12),

              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,
                  ),

                  onPressed: ()async{
                    await CartService.instance.addToCart(userId: userId,productId: widget.productId,quantity: quantity);
                  },
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: CustomScrollView(
        slivers: [
                    SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,

            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () {
                      final discount = (((widget.oldPrice - widget.price) / widget.oldPrice) * 100).round();
                      WishlistService.instance.toggle(
                        image: widget.image,
                        category: widget.category,
                        name: widget.productName,
                        rating: widget.rating,
                        reviews: widget.reviews,
                        price: widget.price.toInt(),
                        discount: discount.toDouble(),
                      );
                      setState(() {
                        favourite = WishlistService.instance.isWishlisted(widget.productName);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WishlistScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      favourite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [

                  Hero(
                    tag: widget.productName,
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: PageView.builder(
                        itemCount: images.length,
                        onPageChanged: (index) {
                          setState(() {
                            selectedImage = index;
                          });
                        },
                        itemBuilder: (_, index) {
                          return InteractiveViewer(
                            child: Image.network(
                              images[index],
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  if (30 > 0)
                    Positioned(
                      top: 90,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          "30% OFF",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (index) {
                          return AnimatedContainer(
                            duration:
                                const Duration(
                              milliseconds: 250,
                            ),
                            margin:
                                const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            width: selectedImage == index
                                ? 22
                                : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color:
                                  selectedImage == index
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                                    Text(
                    widget.category.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.productName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Text(
                              widget.rating
                                  .toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        "${widget.reviews} Reviews",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [

                      Text(
                        "₹${widget.price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        "₹${widget.oldPrice.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          decoration:
                              TextDecoration.lineThrough,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        "40% OFF",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "In Stock • Ready for Delivery",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.local_shipping,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Free delivery available. Estimated delivery in 2–4 business days.",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Premium quality product designed with modern style and durable materials. Perfect for everyday use with excellent comfort, elegant design, and long-lasting performance. Carefully selected to provide the best shopping experience for Shop Aura customers.",
                    style: TextStyle(
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 24),
                                    const Text(
                    "Available Colors",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: List.generate(
                      colors.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 250,
                            ),
                            margin: const EdgeInsets.only(
                              right: 12,
                            ),
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedColor == index
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: colors[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Select Size",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Wrap(
                    spacing: 10,
                    children: List.generate(
                      sizes.length,
                      (index) {
                        final selected =
                            selectedSize == index;

                        return ChoiceChip(
                          label: Text(sizes[index]),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              selectedSize = index;
                            });
                          },
                          selectedColor:
                              AppColors.primary,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : Colors.black,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Quantity",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [

                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.remove_circle_outline,
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Specifications",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Card(
                    elevation: 0,
                    color: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: const [

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Brand",
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text("Shop Aura"),
                            ],
                          ),

                          Divider(),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Category",
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text("Fashion"),
                            ],
                          ),

                          Divider(),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Warranty",
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text("1 Year"),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Customer Reviews",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const ReviewCard(),

                  const ReviewCard(),

                  const SizedBox(height: 40),
                                    const SizedBox(height: 20),

                  const Text(
                    "You May Also Like",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 170,
                          margin: const EdgeInsets.only(right: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Expanded(
                                flex: 6,
                                child: ClipRRect(
                                  borderRadius:
                                      const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    widget.image,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        widget.productName,
                                        maxLines: 2,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),

                                      const Spacer(),

                                      Text(
                                        "₹${widget.price.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                          color:
                                              AppColors.primary,
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}