import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shop_aura/main.dart';
import 'dart:convert';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    _getUser();
    _getProducts();
    _getCategories();
  }

  Future<void> _getUser() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/auth/users"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          users = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> _getProducts() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/product/"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          products = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      print("error: $e");
    }
  }

Future<void> _getCategories()async{
  try{
    final response = await http.get(
      Uri.parse("$baseUrl/category/"),
      headers: {"Content-Type":"application/json"}
    );
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      setState(() {
        categories = List<Map<String, dynamic>>.from(data);
      });
    }
  }catch(e){
    print("error: $e");
  }
}

Future<void> _getOrders()async{
  try{
    final response = await http.get(
      Uri.parse("$baseUrl/orders/"),
      headers: {"Content-Type":"application/json"}
    );
    if(response.statusCode == 200 ){
      final data = jsonDecode(response.body);
      setState(() {
        orders = List<Map<String, dynamic>>.from(data);
      });
    }
  }catch(e){
    print("error: $e");
  }
}
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> orders = [];
  final customers = "";

  String? get baseUrl => Apiconfig.baseUrl;

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "title": "Revenue",
        "count": "₹85,000",
        "icon": Icons.currency_rupee,
        "color": Colors.purple,
      },
      {
        "title": "Orders",
        "count": orders.length.toString(),
        "icon": Icons.shopping_cart_outlined,
        "color": Colors.orange,
      },
      {
        "title": "Products",
        "count": products.length.toString(),
        "icon": Icons.inventory_2_outlined,
        "color": Colors.blue,
      },
      {
        "title": "Customers",
        "count": users.length.toString(),
        "icon": Icons.people_outline,
        "color": Colors.green,
      },
      {
        "title": "Categories",
        "count": categories.length.toString(),
        "icon": Icons.category_outlined,
        "color": Colors.red,
      },
      {
        "title": "Reviews",
        "count": "250",
        "icon": Icons.star_outline,
        "color": Colors.amber,
      },
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;

        if (constraints.maxWidth >= 1200) {
          crossAxisCount = 4; // Desktop
        } else if (constraints.maxWidth >= 800) {
          crossAxisCount = 3; // Tablet
        } else {
          crossAxisCount = 2; // Mobile
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: (item["color"] as Color).withOpacity(0.15),
                    child: Icon(
                      item["icon"] as IconData,
                      color: item["color"] as Color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item["count"] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item["title"] as String,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
