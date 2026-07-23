import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/screens/auth/login/login.dart';
import 'package:shop_aura/frontend/screens/cart_screen.dart';
import 'package:shop_aura/frontend/services/cart_service.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: const BoxDecoration(
        color:AppColors.background,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "ShopAura",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: AppColors.primary,
                  ),
                ),

                // Live item-count badge
                Positioned(
                  right: -2,
                  top: -2,
                  child: ListenableBuilder(
                    listenable: CartService.instance,
                    builder: (context, _) {
                      final count = CartService.instance.itemCount;
                      if (count == 0) return const SizedBox.shrink();

                      return Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.danger,  
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "$count",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width:10),
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child:  IconButton(
              icon: Icon(Icons.person_outline_rounded),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginPage()));
              },
              color: AppColors.primary,
            ),
          ),
        ],

      ),
    );
  }
}