import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/client/screens/auth/login/login.dart';
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