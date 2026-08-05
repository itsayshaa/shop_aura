import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductFilterCard extends StatelessWidget {
  const ProductFilterCard({
    super.key,
    required this.isDesktop,
    required this.searchController,
    required this.selectedCategory,
    required this.selectedBrand,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onBrandChanged,
    required this.onStatusChanged,
    required this.onClear,
  });

  final bool isDesktop;

  final TextEditingController searchController;

  final String selectedCategory;
  final String selectedBrand;
  final String selectedStatus;

  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onBrandChanged;
  final ValueChanged<String?> onStatusChanged;

  final VoidCallback onClear;

  static const List<String> categories = [
    'All Categories',
    'Mobiles',
    'Electronics',
    'Kitchen',
  ];

  static const List<String> brands = [
    'All Brands',
    'Samsung',
    'Boat',
    'Hawkins',
    'Apple',
  ];

  static const List<String> statuses = [
    'All Status',
    'Active',
    'Inactive',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _searchField(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown(
                    value: selectedCategory,
                    items: categories,
                    onChanged: onCategoryChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown(
                    value: selectedBrand,
                    items: brands,
                    onChanged: onBrandChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown(
                    value: selectedStatus,
                    items: statuses,
                    onChanged: onStatusChanged,
                  ),
                ),
                const SizedBox(width: 12),
                _clearButton(),
              ],
            )
          : Column(
              children: [
                _searchField(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _dropdown(
                        value: selectedCategory,
                        items: categories,
                        onChanged: onCategoryChanged,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _dropdown(
                        value: selectedBrand,
                        items: brands,
                        onChanged: onBrandChanged,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _dropdown(
                        value: selectedStatus,
                        items: statuses,
                        onChanged: onStatusChanged,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _clearButton(
                        fullWidth: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: searchController,
      onChanged: onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(
          Icons.search_rounded,
        ),
        suffixIcon: searchController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  searchController.clear();
                  onSearchChanged('');
                },
                icon: const Icon(
                  Icons.close_rounded,
                ),
              ),
        filled: true,
        fillColor: const Color(0xFFF8F8FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FA),
        borderRadius: BorderRadius.circular(11),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _clearButton({
    bool fullWidth = false,
  }) {
    return SizedBox(
      width: fullWidth
          ? double.infinity
          : null,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onClear,
        icon: const Icon(
          Icons.filter_alt_off_outlined,
        ),
        label: const Text('Clear'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDark,
          side: BorderSide(
            color: Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }
}