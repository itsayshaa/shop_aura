import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_aura/frontend/services/cart_service.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_aura/main.dart';
import 'package:shop_aura/backend/models/client/cartModel/cartModel.dart';
import 'package:shop_aura/frontend/client/screens/payment/payment_screen.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<CartModel> cartFuture;
  @override
  void initState() {
    super.initState();
    loadCart();
  }
  Future<void>loadCart()async{
    await getUserId();
    setState(() {
      cartFuture = CartService().getCart(userId);
    });
  }
  String? get baseUrl => Apiconfig.baseUrl;
  String userId = "";
  Future<void> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString("userId") ?? "";
    // if (userid.isEmpty) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (_) => LoginPage()),
    //   );
    //   return;
    // }
    setState(() {
      userId = userid;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.primary,
        title: const Text(
          "My Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: userId.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: cartFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if(snapshot.hasError){
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}"
                    ),
                  );
                }
                if(!snapshot.hasData){
                  return const Center(
                    child: Text(
                      "No cart Found"
                    ),
                  );
                }
                final cart = snapshot.data!;
                final items = cart.products;

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          'assets/lottieanimtion/emptycart/empty.json',
                          width: 220,
                          height: 220,
                          fit: BoxFit.contain,
                          repeat: true,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Your cart is empty",
                          style: TextStyle(
                            color: AppColors.textSoft,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = items[index];

                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(
                              milliseconds: 300 + (index * 60),
                            ),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, (1 - value) * 20),
                                  child: child,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      item.image,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 70,
                                        height: 70,
                                        color: AppColors.secondarySoft,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 2),
                                        Text(
                                          item.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "₹${item.price}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          _QtyButton(
                                            icon: Icons.remove,
                                            onTap: ()async{
                                              await CartService().decreaseQuantity(userId: userId, productId: item.productId.oid);
                                              setState(() {
                                                cartFuture = CartService().getCart(userId);
                                              });
                                            }
                                          ),
                                          SizedBox(
                                            width: 28,
                                            child: Text(
                                              "${item.quantity}",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          _QtyButton(
                                            icon: Icons.add,
                                            onTap:()async{
                                              await CartService().increaseQuantity(userId: userId,productId: item.productId.oid);
                                              setState(() {
                                                cartFuture = CartService().getCart(userId);
                                              });
                                            }
                                          ),
                                        ],
                                      ),
                                      TextButton.icon(
                                        onPressed: ()async{
                                          await CartService().removeItem(userId: userId, productId: item.productId.oid);
                                          setState(() {
                                            cartFuture = CartService().getCart(userId);
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(0, 0),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        icon: Icon(
                                          Icons.delete_outline_rounded,
                                          size: 25,
                                          color: AppColors.danger,
                                        ),
                                        label: Text(
                                          " ",
                                          style: TextStyle(
                                            color: AppColors.danger,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        top: false,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                      color: AppColors.textSoft,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "₹${cart.finalTotal}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>  PaymentScreen(
                                      items: cart.products,
                                      total: cart.finalTotal
                                    )
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "BUY NOW",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 14, color: AppColors.primary),
      ),
    );
  }
}
