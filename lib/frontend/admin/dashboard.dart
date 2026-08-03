import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/admin/widgets/bottombar.dart';
import 'package:shop_aura/frontend/admin/widgets/drawer.dart';
import 'package:shop_aura/frontend/admin/widgets/income.dart';
import 'package:shop_aura/frontend/admin/widgets/low_stock.dart';
import 'package:shop_aura/frontend/admin/widgets/recent_orders.dart';
import 'package:shop_aura/frontend/admin/widgets/sales_chat.dart';
import 'package:shop_aura/frontend/admin/widgets/top_products.dart';
import 'package:shop_aura/frontend/client/screens/widgets/section_card.dart';
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
      home:  DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget{
  @override
  State<DashboardScreen> createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen>{
  int selectedIndex = 0;
  int _navIndex = 0;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Pane"),
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
  onDestinationSelected: (index){
    setState(() {
      _navIndex = index;
    });
  },
),
      body: SafeArea(
        child: SingleChildScrollView(
          child:Padding(
            padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Text(
                "DashBoard",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.accent
                ),
                ),
                SizedBox(height: 5,),
                Text(
                  "Welcome back admin",
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 30,),
                DashboardPage(),
                SizedBox(height: 10,),
                SectionCard(
                  title: "Sales Overview",
                  child: SalesChart(),
                  icon: Icons.grain_sharp
                ),
                SizedBox(height: 10,),
                LowStockWidget(),
                SizedBox(height: 10,),
                RecentOrdersWidget(),
                SizedBox(height: 10,),
                TopProductsWidget()
            ],
          ),
          )
        ),
      )
    );
  }
}