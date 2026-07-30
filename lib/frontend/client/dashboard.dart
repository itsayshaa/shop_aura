import 'package:flutter/material.dart';
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

/// ---------- MODELS ----------
class StatCardData {
  final String title;
  final String value;
  final String subtitle;
  final Color subtitleColor;
  final IconData icon;
  StatCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.subtitleColor,
    required this.icon,
  });
}

class OrderRow {
  final String id;
  final String customer;
  final String total;
  final String status;
  OrderRow(this.id, this.customer, this.total, this.status);
}

class ProductRow {
  final String name;
  final int sold;
  final int stock;
  ProductRow(this.name, this.sold, this.stock);
}

/// ---------- DASHBOARD SCREEN ----------
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;

  final stats = [
    StatCardData(
      title: 'Revenue',
      value: '₹6,962',
      subtitle: 'Total Revenue',
      subtitleColor: AppColors.green,
      icon: Icons.currency_rupee_rounded,
    ),
    StatCardData(
      title: 'Orders',
      value: '9',
      subtitle: '6 Pending',
      subtitleColor: AppColors.green,
      icon: Icons.shopping_cart_outlined,
    ),
    StatCardData(
      title: 'Products',
      value: '9',
      subtitle: '0 Low Stock',
      subtitleColor: AppColors.green,
      icon: Icons.inventory_2_outlined,
    ),
    StatCardData(
      title: 'Customers',
      value: '4',
      subtitle: 'Total Registered Users',
      subtitleColor: AppColors.green,
      icon: Icons.people_outline_rounded,
    ),
  ];

  final orders = [
    OrderRow('#1009', 'Afsal', '₹258.42', 'Pending'),
    OrderRow('#1008', 'Afsal', '₹1313.64', 'Pending'),
    OrderRow('#1007', 'Sinan', '₹899.00', 'Delivered'),
  ];

  final products = [
    ProductRow('Samsung Galaxy S24 Ultra 5G', 0, 20),
    ProductRow('Hawkins 5 Litre Pressure Cooker', 0, 40),
    ProductRow('Boat Airdopes 141', 3, 25),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const _AdminDrawer(),
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 700));
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: const [
                Text(
                  'Welcome back, Admin ',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                ),
                Text('👋', style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 20),
            _StatGrid(stats: stats),
            const SizedBox(height: 20),
            _SalesOverviewCard(),
            const SizedBox(height: 20),
            _LowStockCard(),
            const SizedBox(height: 20),
            _RecentOrdersCard(orders: orders),
            const SizedBox(height: 20),
            _TopProductsCard(products: products),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textDark),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      title: const Text(
        'Admin Panel',
        style: TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded,
              color: AppColors.textDark),
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          offset: const Offset(0, 45),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'profile', child: Text('Profile')),
            const PopupMenuItem(value: 'settings', child: Text('Settings')),
            const PopupMenuItem(value: 'logout', child: Text('Logout')),
          ],
          child: const Padding(
            padding: EdgeInsets.only(right: 12, left: 4),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              child: Text(
                'S',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _navIndex,
      onDestinationSelected: (i) => setState(() => _navIndex = i),
      backgroundColor: Colors.white,
      indicatorColor: AppColors.primaryHover,
      height: 64,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.grid_view_rounded),
          selectedIcon: Icon(Icons.grid_view_rounded, color: AppColors.primary),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2_rounded, color: AppColors.primary),
          label: 'Products',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long_rounded, color: AppColors.primary),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline_rounded),
          selectedIcon: Icon(Icons.people_rounded, color: AppColors.primary),
          label: 'Customers',
        ),
        NavigationDestination(
          icon: Icon(Icons.more_horiz_rounded),
          selectedIcon: Icon(Icons.more_horiz_rounded, color: AppColors.primary),
          label: 'More',
        ),
      ],
    );
  }
}

/// ---------- DRAWER (full menu, mirrors sidebar) ----------
class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer();

  static const items = [
    ['Dashboard', Icons.grid_view_rounded],
    ['Products', Icons.inventory_2_outlined],
    ['Categories', Icons.category_outlined],
    ['Orders', Icons.shopping_cart_outlined],
    ['Refunds', Icons.replay_outlined],
    ['Brands', Icons.local_offer_outlined],
    ['Customers', Icons.people_outline_rounded],
    ['Staff', Icons.badge_outlined],
    ['Coupons', Icons.confirmation_number_outlined],
    ['About', Icons.info_outline_rounded],
    ['Contact', Icons.mail_outline_rounded],
    ['Banners', Icons.image_outlined],
    ['Reviews', Icons.star_border_rounded],
    ['Policies', Icons.privacy_tip_outlined],
    ['Settings', Icons.settings_outlined],
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                'Admin Panel',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final isSelected = i == 0;
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      dense: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      leading: Icon(
                        items[i][1] as IconData,
                        size: 20,
                        color: isSelected ? Colors.white : AppColors.textGrey,
                      ),
                      title: Text(
                        items[i][0] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.white : AppColors.textDark,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text('Logout',
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// ---------- STAT GRID (2 columns on mobile) ----------
class _StatGrid extends StatelessWidget {
  final List<StatCardData> stats;
  const _StatGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, i) => _StatCard(data: stats[i]),
    );
  }
}

class _StatCard extends StatelessWidget {
  final StatCardData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryHover,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            data.title,
            style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              data.value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: data.subtitleColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// ---------- SALES OVERVIEW ----------
class _SalesOverviewCard extends StatelessWidget {
  const _SalesOverviewCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Sales Overview',
      trailingIcon: Icons.trending_up_rounded,
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: CustomPaint(
          painter: _ChartPainter(),
          child: const Center(
            child: Text(
              'Chart Area',
              style: TextStyle(color: AppColors.textGrey, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.primaryHover.withOpacity(0.7),
          AppColors.primaryHover.withOpacity(0.1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ---------- LOW STOCK ----------
class _LowStockCard extends StatelessWidget {
  const _LowStockCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Low Stock',
      trailingIcon: Icons.warning_amber_rounded,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No low stock products',
            style: TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}

/// ---------- RECENT ORDERS ----------
class _RecentOrdersCard extends StatelessWidget {
  final List<OrderRow> orders;
  const _RecentOrdersCard({required this.orders});

  Color _statusColor(String status) {
    switch (status) {
      case 'Delivered':
        return AppColors.green;
      case 'Pending':
      default:
        return AppColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Recent Orders',
      child: Column(
        children: orders
            .map((o) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(o.id,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: AppColors.textDark)),
                            const SizedBox(height: 2),
                            Text(o.customer,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.textGrey)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          o.total,
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textDark),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.greenBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              o.status,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _statusColor(o.status),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

/// ---------- TOP PRODUCTS ----------
class _TopProductsCard extends StatelessWidget {
  final List<ProductRow> products;
  const _TopProductsCard({required this.products});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Top Products',
      child: Column(
        children: products
            .map((p) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.name,
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textDark),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 50,
                        child: Text(
                          'Sold ${p.sold}',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textGrey),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          'Stock ${p.stock}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textGrey),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

/// ---------- SHARED SECTION CARD WRAPPER ----------
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData? trailingIcon;
  final Widget child;
  const _SectionCard({
    required this.title,
    required this.child,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              if (trailingIcon != null)
                Icon(trailingIcon, size: 18, color: AppColors.textGrey),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
