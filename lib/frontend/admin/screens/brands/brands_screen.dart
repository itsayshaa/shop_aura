  import 'package:flutter/material.dart';

  import 'package:shop_aura/frontend/admin/models/brand_model.dart';
  import 'package:shop_aura/frontend/admin/screens/brands/add_brand_screen.dart';
  import 'package:shop_aura/frontend/admin/widgets/brands/brand_mobile_card.dart';
  import 'package:shop_aura/frontend/admin/widgets/brands/brand_table.dart';
  import 'package:shop_aura/frontend/theme/app_colors.dart';

  class BrandsScreen extends StatefulWidget {
    const BrandsScreen({super.key});

    @override
    State<BrandsScreen> createState() => _BrandsScreenState();
  }

  class _BrandsScreenState extends State<BrandsScreen> {
    final TextEditingController _searchController = TextEditingController();

    String _searchText = '';

    final List<BrandModel> _brands = [
      const BrandModel(
        id: '1',
        name: 'Ashirvaad',
        slug: 'ashirvaad',
        description: 'Quality food and grocery products.',
        isActive: true,
      ),
      const BrandModel(
        id: '2',
        name: 'Adidas',
        slug: 'adidas',
        description: 'Stylish athletic footwear, apparel, and sports equipment.',
        isActive: true,
      ),
      const BrandModel(
        id: '3',
        name: 'Amul',
        slug: 'amul',
        description: 'Trusted dairy and food products for everyday use.',
        isActive: true,
      ),
      const BrandModel(
        id: '4',
        name: 'Apple',
        slug: 'apple',
        description: 'Premium smartphones, laptops, tablets, and accessories.',
        isActive: true,
      ),
      const BrandModel(
        id: '5',
        name: 'Cosco',
        slug: 'cosco',
        description: 'Sports goods, fitness products, and outdoor equipment.',
        isActive: true,
      ),
      const BrandModel(
        id: '6',
        name: 'Dell',
        slug: 'dell',
        description: 'Reliable laptops, desktops, and computer accessories.',
        isActive: true,
      ),
      const BrandModel(
        id: '7',
        name: 'Godrej',
        slug: 'godrej',
        description: 'Home appliances, furniture, and consumer products.',
        isActive: true,
      ),
      const BrandModel(
        id: '8',
        name: 'H&M',
        slug: 'hm',
        description:
            'Modern clothing, fashion accessories, and lifestyle products.',
        isActive: true,
      ),
      const BrandModel(
        id: '9',
        name: 'HP',
        slug: 'hp',
        description: 'Computers, printers, laptops, and technology products.',
        isActive: true,
      ),
      const BrandModel(
        id: '10',
        name: 'IKEA',
        slug: 'ikea',
        description: 'Affordable furniture, home decor, and household products.',
        isActive: true,
      ),
      const BrandModel(
        id: '11',
        name: 'LG',
        slug: 'lg',
        description: 'Electronics, home appliances, and smart technology.',
        isActive: true,
      ),
      const BrandModel(
        id: '12',
        name: 'Lakme',
        slug: 'lakme',
        description: 'Beauty, skincare, cosmetics, and makeup products.',
        isActive: true,
      ),
      const BrandModel(
        id: '13',
        name: 'L\'Oréal',
        slug: 'loreal',
        description: 'Professional beauty, skincare, haircare, and cosmetics.',
        isActive: true,
      ),
      const BrandModel(
        id: '14',
        name: 'Maybelline',
        slug: 'maybelline',
        description: 'Makeup and beauty products for everyday use.',
        isActive: true,
      ),
      const BrandModel(
        id: '15',
        name: 'Nestlé',
        slug: 'nestle',
        description: 'Food, beverages, nutrition, and household products.',
        isActive: true,
      ),
      const BrandModel(
        id: '16',
        name: 'Nike',
        slug: 'nike',
        description: 'Sportswear, athletic shoes, clothing, and accessories.',
        isActive: true,
      ),
      const BrandModel(
        id: '17',
        name: 'Nilkamal',
        slug: 'nilkamal',
        description: 'Furniture, home products, and storage solutions.',
        isActive: true,
      ),
      const BrandModel(
        id: '18',
        name: 'Nivia',
        slug: 'nivia',
        description: 'Sports equipment, fitness products, and accessories.',
        isActive: true,
      ),
      const BrandModel(
        id: '19',
        name: 'OnePlus',
        slug: 'oneplus',
        description: 'Smartphones, smart devices, and electronic accessories.',
        isActive: true,
      ),
      const BrandModel(
        id: '20',
        name: 'Oxford',
        slug: 'oxford',
        description: 'Educational books, stationery, and learning products.',
        isActive: true,
      ),
      const BrandModel(
        id: '21',
        name: 'Penguin',
        slug: 'penguin',
        description: 'Books, educational materials, and publications.',
        isActive: true,
      ),
      const BrandModel(
        id: '22',
        name: 'Puma',
        slug: 'puma',
        description: 'Sportswear, footwear, clothing, and accessories.',
        isActive: true,
      ),
      const BrandModel(
        id: '23',
        name: 'Samsung',
        slug: 'samsung',
        description: 'Smartphones, electronics, home appliances, and technology.',
        isActive: true,
      ),
      const BrandModel(
        id: '24',
        name: 'Sony',
        slug: 'sony',
        description: 'Electronics, entertainment, audio, and gaming products.',
        isActive: true,
      ),
      const BrandModel(
        id: '25',
        name: 'Xiaomi',
        slug: 'xiaomi',
        description: 'Smartphones, smart devices, and electronic products.',
        isActive: true,
      ),
      const BrandModel(
        id: '26',
        name: 'Yonex',
        slug: 'yonex',
        description: 'Badminton, tennis, sports equipment, and accessories.',
        isActive: true,
      ),
      const BrandModel(
        id: '27',
        name: 'Zara',
        slug: 'zara',
        description: 'Fashion clothing, footwear, and lifestyle accessories.',
        isActive: true,
      ),
    ];

    List<BrandModel> get _filteredBrands {
      if (_searchText.trim().isEmpty) {
        return _brands;
      }

      final query = _searchText.toLowerCase().trim();

      return _brands.where((brand) {
        return brand.name.toLowerCase().contains(query) ||
            brand.slug.toLowerCase().contains(query);
      }).toList();
    }

    @override
    void dispose() {
      _searchController.dispose();
      super.dispose();
    }

    void _openAddBrandScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddBrandScreen()),
      );
    }

    void _editBrand(BrandModel brand) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddBrandScreen(brand: brand)),
      );
    }

    void _deleteBrand(BrandModel brand) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Delete Brand'),
            content: Text('Are you sure you want to delete ${brand.name}?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _brands.removeWhere((item) => item.id == brand.id);
                  });

                  Navigator.pop(dialogContext);
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
    }

    @override
    Widget build(BuildContext context) {
      final brands = _filteredBrands;

      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 700;

                  if (isMobile) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),

                        const SizedBox(height: 18),

                        _buildAddButton(),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildTitle()),

                      _buildAddButton(),
                    ],
                  );
                },
              ),

              const SizedBox(height: 28),

              _buildSearchField(),

              const SizedBox(height: 22),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 850;

                  if (brands.isEmpty) {
                    return _buildEmptyState();
                  }

                  if (isMobile) {
                    return Column(
                      children: brands.map((brand) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: BrandMobileCard(
                            brand: brand,
                            onEdit: () {
                              _editBrand(brand);
                            },
                            onDelete: () {
                              _deleteBrand(brand);
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }

                  return BrandTable(
                    brands: brands,
                    onEdit: _editBrand,
                    onDelete: _deleteBrand,
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildTitle() {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Brands',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          SizedBox(height: 6),

          Text(
            'Manage your product brands',
            style: TextStyle(fontSize: 16, color: AppColors.textGrey),
          ),
        ],
      );
    }

    Widget _buildAddButton() {
      return SizedBox(
        height: 52,
        child: ElevatedButton.icon(
          onPressed: _openAddBrandScreen,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Brand'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }

    Widget _buildSearchField() {
      return SizedBox(
        width: 380,
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search brand...',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 17),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
            ),
          ),
        ),
      );
    }

    Widget _buildEmptyState() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Column(
          children: [
            Icon(Icons.storefront_outlined, size: 54, color: AppColors.textGrey),

            SizedBox(height: 15),

            Text(
              'No brands found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),

            SizedBox(height: 6),

            Text(
              'Try another search or add a new brand.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey),
            ),
          ],
        ),
      );
    }
  }
