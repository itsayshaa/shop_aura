import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_theme.dart';
import 'package:shop_aura/frontend/client/screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const ShopAuraApp());
}

class ShopAuraApp extends StatefulWidget {
  const ShopAuraApp({super.key});

  @override
  State<ShopAuraApp> createState() => _ShopAuraAppState();
}

class _ShopAuraAppState extends State<ShopAuraApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Aura',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
