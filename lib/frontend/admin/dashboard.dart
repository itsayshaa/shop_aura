import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/admin/widgets/bottombar.dart';
import 'package:shop_aura/frontend/admin/widgets/drawer.dart';
import 'package:shop_aura/frontend/admin/widgets/income.dart';
import 'package:shop_aura/frontend/admin/screens/admin_orders_screen.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF7F7F9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7A1F3D)),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  int _navIndex = 0;

  String get _appBarTitle {
    switch (selectedIndex) {
      case 3:
        return "Orders Management";
      case 4:
        return "Refund Requests";
      default:
        return "Admin Panel";
    }
  }

  Widget _buildBody() {
    if (selectedIndex == 3) {
      return const AdminOrdersScreen(initialRefundsFilter: false);
    } else if (selectedIndex == 4) {
      return const AdminOrdersScreen(initialRefundsFilter: true);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dashboard",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Welcome back admin",
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            DashboardPage(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0.5,
      ),
      drawer: AdminDrawer(
        selectedIndex: selectedIndex,
        onItemSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: AdminBottomNav(
        currentIndex: _navIndex,
        onDestinationSelected: (index) {
          setState(() {
            _navIndex = index;
          });
        },
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }
}