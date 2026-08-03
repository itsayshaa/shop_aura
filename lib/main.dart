import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'frontend/theme/app_theme.dart';
import 'frontend/client/screens/main_navigation_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'frontend/providers/category_provider.dart';
import 'frontend/providers/product_provider.dart';
import 'frontend/providers/search_provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  runApp(const ShopAuraApp());
}
class Apiconfig{
  static String get baseUrl=> dotenv.env["API_URL"] ?? "";

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