import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/client/screens/auth/login/login.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/client/screens/cart_screen.dart';
import 'package:shop_aura/frontend/client/screens/profilescreen.dart';
import 'package:shop_aura/frontend/services/cart_service.dart';
import 'package:shop_aura/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import 'dart:convert';
class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}
String? get baseUrl => Apiconfig.baseUrl;
class _HomeHeaderState extends State<HomeHeader> {
  String userId = "";

  @override
  void initState(){
    super.initState();
    getUserId();
  }
  Future<void> getUserId()async{
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString("userId") ?? "";
    // if(userid.isEmpty){
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
    //   return;
    // }
    setState(() {
      userId = userid;
    });
  }

  Future<int> getCartCount(String userId) async {
  final response = await http.get(
    Uri.parse("$baseUrl/cart/count/$userId"),
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    return body["count"];
  }

  throw Exception("Failed to load cart count");
}
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Row(
        children: [

          const Expanded(
            child: Text(
              "ShopAura",
              style: TextStyle(
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
                MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                ),
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
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: AppColors.primary,
                  ),
                ),

                Positioned(
                  right: -2,
                  top: -2,
                  child: FutureBuilder<int>(
  future: userId.isEmpty ? Future.value(0) : getCartCount(userId),
  builder: (context, snapshot) {
    if (!snapshot.hasData || snapshot.data == 0) {
      return const SizedBox.shrink();
    }

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
        "${snapshot.data}",
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

          const SizedBox(width: 10),

          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.person_outline_rounded,
              ),
              color: AppColors.primary,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
