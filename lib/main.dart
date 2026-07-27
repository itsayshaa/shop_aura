import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'frontend/theme/app_theme.dart';
import 'frontend/client/screens/main_navigation_screen.dart';

import 'frontend/providers/category_provider.dart';
import 'frontend/providers/product_provider.dart';
import 'frontend/providers/search_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ShopAuraApp());
}

class ShopAuraApp extends StatelessWidget {
  const ShopAuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => SearchProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Shop Aura",
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}