import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/screens/products/add_product_screen.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_filter_card.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_image_box.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_mobile_card.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_stat_card.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_status_badge.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_table.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String selectedCategory = 'All Categories';
  String selectedBrand = 'All Brands';
  String selectedStatus = 'All Status';

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Samsung Galaxy S24 Ultra',
      'category': 'Mobiles',
      'brand': 'Samsung',
      'price': 129999,
      'stock': 20,
      'status': 'Active',
    },
    {
      'name': 'Boat Airdopes 141',
      'category': 'Electronics',
      'brand': 'Boat',
      'price': 1499,
      'stock': 8,
      'status': 'Active',
    },
    {
      'name': 'Hawkins Pressure Cooker',
      'category': 'Kitchen',
      'brand': 'Hawkins',
      'price': 2499,
      'stock': 40,
      'status': 'Active',
    },
    {
      'name': 'Apple iPhone 15 Pro',
      'category': 'Mobiles',
      'brand': 'Apple',
      'price': 134900,
      'stock': 0,
      'status': 'Inactive',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredProducts {
    final searchText = _searchController.text.toLowerCase().trim();

    return products.where((product) {
      final matchesSearch =
          product['name'].toString().toLowerCase().contains(searchText) ||
          product['brand'].toString().toLowerCase().contains(searchText);

      final matchesCategory =
          selectedCategory == 'All Categories' ||
          product['category'] == selectedCategory;

      final matchesBrand =
          selectedBrand == 'All Brands' || product['brand'] == selectedBrand;

      final matchesStatus =
          selectedStatus == 'All Status' || product['status'] == selectedStatus;

      return matchesSearch && matchesCategory && matchesBrand && matchesStatus;
    }).toList();
  }

  Future<void> _addProduct() async {
    final newProduct = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const AddProductScreen()),
    );

    if (newProduct == null) return;

    setState(() {
      products.add(newProduct);
    });

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Product added successfully')));
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();

      selectedCategory = 'All Categories';
      selectedBrand = 'All Brands';
      selectedStatus = 'All Status';
    });
  }

  Future<void> _viewProduct(Map<String, dynamic> product) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Row(
            children: [
              Icon(Icons.visibility_outlined, color: AppColors.primary),

              SizedBox(width: 10),

              Expanded(child: Text('Product Details')),
            ],
          ),

          content: SizedBox(
            width: 400,

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  const ProductImageBox(),

                  const SizedBox(height: 20),

                  Text(
                    product['name'].toString(),

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 19,

                      fontWeight: FontWeight.w800,

                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _viewDetailRow(
                    'Category',

                    product['category'].toString(),

                    Icons.category_outlined,
                  ),

                  _viewDetailRow(
                    'Brand',

                    product['brand'].toString(),

                    Icons.business_outlined,
                  ),

                  _viewDetailRow(
                    'Price',

                    '₹${product['price']}',

                    Icons.currency_rupee,
                  ),

                  _viewDetailRow(
                    'Stock',

                    '${product['stock']}',

                    Icons.inventory_2_outlined,
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,

                        size: 20,

                        color: AppColors.textGrey,
                      ),

                      const SizedBox(width: 12),

                      const Text(
                        'Status',

                        style: TextStyle(color: AppColors.textGrey),
                      ),

                      const Spacer(),

                      ProductStatusBadge(status: product['status'].toString()),
                    ],
                  ),
                ],
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _viewDetailRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textGrey),

          const SizedBox(width: 12),

          Text(title, style: const TextStyle(color: AppColors.textGrey)),

          const Spacer(),

          Flexible(
            child: Text(
              value,

              textAlign: TextAlign.right,

              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                fontWeight: FontWeight.w700,

                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editProduct(Map<String, dynamic> product) async {
    final nameController = TextEditingController(
      text: product['name'].toString(),
    );

    final categoryController = TextEditingController(
      text: product['category'].toString(),
    );

    final brandController = TextEditingController(
      text: product['brand'].toString(),
    );

    final priceController = TextEditingController(
      text: product['price'].toString(),
    );

    final stockController = TextEditingController(
      text: product['stock'].toString(),
    );

    String editStatus = product['status'].toString();

    final updated = await showDialog<bool>(
      context: context,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              title: const Row(
                children: [
                  Icon(Icons.edit_outlined, color: AppColors.primary),

                  SizedBox(width: 10),

                  Text('Edit Product'),
                ],
              ),

              content: SizedBox(
                width: 450,

                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      _editTextField(
                        controller: nameController,

                        label: 'Product Name',

                        icon: Icons.inventory_2_outlined,
                      ),

                      const SizedBox(height: 13),

                      _editTextField(
                        controller: categoryController,

                        label: 'Category',

                        icon: Icons.category_outlined,
                      ),

                      const SizedBox(height: 13),

                      _editTextField(
                        controller: brandController,

                        label: 'Brand',

                        icon: Icons.business_outlined,
                      ),

                      const SizedBox(height: 13),

                      _editTextField(
                        controller: priceController,

                        label: 'Price',

                        icon: Icons.currency_rupee,

                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 13),

                      _editTextField(
                        controller: stockController,

                        label: 'Stock',

                        icon: Icons.inventory_outlined,

                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 13),

                      DropdownButtonFormField<String>(
                        value: editStatus,

                        decoration: InputDecoration(
                          labelText: 'Status',

                          prefixIcon: const Icon(Icons.check_circle_outline),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        items: const [
                          DropdownMenuItem(
                            value: 'Active',

                            child: Text('Active'),
                          ),

                          DropdownMenuItem(
                            value: 'Inactive',

                            child: Text('Inactive'),
                          ),
                        ],

                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          setDialogState(() {
                            editStatus = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },

                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();

                    final category = categoryController.text.trim();

                    final brand = brandController.text.trim();

                    final price = int.tryParse(priceController.text.trim());

                    final stock = int.tryParse(stockController.text.trim());

                    if (name.isEmpty ||
                        category.isEmpty ||
                        brand.isEmpty ||
                        price == null ||
                        stock == null) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter all product details'),
                        ),
                      );

                      return;
                    }

                    setState(() {
                      product['name'] = name;

                      product['category'] = category;

                      product['brand'] = brand;

                      product['price'] = price;

                      product['stock'] = stock;

                      product['status'] = editStatus;
                    });

                    Navigator.pop(dialogContext, true);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,

                    foregroundColor: Colors.white,
                  ),

                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    categoryController.dispose();
    brandController.dispose();
    priceController.dispose();
    stockController.dispose();

    if (updated == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully')),
      );
    }
  }

  Widget _editTextField({
    required TextEditingController controller,

    required String label,

    required IconData icon,

    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,

      keyboardType: keyboardType,

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(icon),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _deleteProduct(Map<String, dynamic> product) async {
    final shouldDelete = await showDialog<bool>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          title: const Text('Delete Product'),

          content: Text(
            'Do you want to delete '
            '${product['name']}?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,

                foregroundColor: Colors.white,
              ),

              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      products.remove(product);
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product deleted successfully')),
    );
  }

  void _toggleStatus(Map<String, dynamic> product) {
    setState(() {
      product['status'] == 'Active'
          ? product['status'] = 'Inactive'
          : product['status'] = 'Active';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${product['name']} is now '
          '${product['status']}',
        ),
      ),
    );
  }

  void _handleProductAction(String action, Map<String, dynamic> product) {
    switch (action) {
      case 'view':
        _viewProduct(product);
        break;

      case 'edit':
        _editProduct(product);
        break;

      case 'status':
        _toggleStatus(product);
        break;

      case 'delete':
        _deleteProduct(product);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F6F8),

      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 850;

            return ListView(
              padding: EdgeInsets.all(isDesktop ? 25 : 15),

              children: [
                _buildPageHeader(isDesktop),

                const SizedBox(height: 22),

                _buildStatistics(isDesktop),

                const SizedBox(height: 20),

                ProductFilterCard(
                  isDesktop: isDesktop,

                  searchController: _searchController,

                  selectedCategory: selectedCategory,

                  selectedBrand: selectedBrand,

                  selectedStatus: selectedStatus,

                  onSearchChanged: (value) {
                    setState(() {});
                  },

                  onCategoryChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      selectedCategory = value;
                    });
                  },

                  onBrandChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      selectedBrand = value;
                    });
                  },

                  onStatusChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      selectedStatus = value;
                    });
                  },

                  onClear: _clearFilters,
                ),

                const SizedBox(height: 20),

                if (isDesktop)
                  ProductTable(
                    products: filteredProducts,

                    onMenuSelected: _handleProductAction,
                  )
                else
                  _buildMobileProducts(),

                const SizedBox(height: 25),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageHeader(bool isDesktop) {
    if (isDesktop) {
      return Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Products',

                  style: TextStyle(
                    fontSize: 28,

                    fontWeight: FontWeight.w800,

                    color: AppColors.textDark,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Manage your products, pricing and inventory',

                  style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                ),
              ],
            ),
          ),

          ElevatedButton.icon(
            onPressed: _addProduct,

            icon: const Icon(Icons.add_rounded),

            label: const Text('Add Product'),

            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,

              foregroundColor: Colors.white,

              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          'Products',

          style: TextStyle(
            fontSize: 25,

            fontWeight: FontWeight.w800,

            color: AppColors.textDark,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Manage products and inventory',

          style: TextStyle(fontSize: 13, color: AppColors.textGrey),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,

          child: ElevatedButton.icon(
            onPressed: _addProduct,

            icon: const Icon(Icons.add_rounded),

            label: const Text('Add Product'),

            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,

              foregroundColor: Colors.white,

              padding: const EdgeInsets.symmetric(vertical: 16),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(bool isDesktop) {
    final activeCount = products
        .where((product) => product['status'] == 'Active')
        .length;

    final inactiveCount = products
        .where((product) => product['status'] == 'Inactive')
        .length;

    final lowStockCount = products.where((product) {
      final stock = product['stock'] as int;

      return stock > 0 && stock <= 10;
    }).length;

    final cards = [
      ProductStatCard(
        title: 'Total Products',

        value: '${products.length}',

        icon: Icons.inventory_2_outlined,
      ),

      ProductStatCard(
        title: 'Active Products',

        value: '$activeCount',

        icon: Icons.check_circle_outline,
      ),

      ProductStatCard(
        title: 'Low Stock',

        value: '$lowStockCount',

        icon: Icons.warning_amber_rounded,
      ),

      ProductStatCard(
        title: 'Inactive',

        value: '$inactiveCount',

        icon: Icons.pause_circle_outline,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),

      itemCount: cards.length,

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 4 : 2,

        crossAxisSpacing: 12,

        mainAxisSpacing: 12,

        childAspectRatio: isDesktop ? 2.1 : 1.55,
      ),

      itemBuilder: (context, index) {
        return cards[index];
      },
    );
  }

  Widget _buildMobileProducts() {
    if (filteredProducts.isEmpty) {
      return Container(
        height: 260,

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(16),
        ),

        child: const Center(child: Text('No products found')),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          children: [
            const Text(
              'All Products',

              style: TextStyle(
                fontSize: 18,

                fontWeight: FontWeight.w800,

                color: AppColors.textDark,
              ),
            ),

            const Spacer(),

            Text(
              '${filteredProducts.length} items',

              style: const TextStyle(color: AppColors.textGrey),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ...filteredProducts.map((product) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),

            child: ProductMobileCard(
              product: product,

              onMenuSelected: (action) {
                _handleProductAction(action, product);
              },
            ),
          );
        }),
      ],
    );
  }
}
