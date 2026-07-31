import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/models/category_model.dart';
import 'package:shop_aura/frontend/admin/screens/categories/add_category_screen.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_mobile_card.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_table.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _selectedStatus = 'All Status';

  final List<CategoryModel> _categories = [
    CategoryModel(
      id: '1',
      name: 'Electronics',
      slug: 'electronics',
      description:
          'Mobile phones, laptops, accessories and electronics.',
      parentName: 'No Parent',
      imagePath: null,
      productCount: 24,
      isActive: true,
    ),
    CategoryModel(
      id: '2',
      name: 'Mobiles',
      slug: 'mobiles',
      description:
          'Smartphones and mobile accessories.',
      parentName: 'Electronics',
      imagePath: null,
      productCount: 18,
      isActive: true,
    ),
    CategoryModel(
      id: '3',
      name: 'Fashion',
      slug: 'fashion',
      description:
          'Clothing, footwear and fashion accessories.',
      parentName: 'No Parent',
      imagePath: null,
      productCount: 32,
      isActive: true,
    ),
    CategoryModel(
      id: '4',
      name: 'Home & Kitchen',
      slug: 'home-kitchen',
      description:
          'Home appliances and kitchen products.',
      parentName: 'No Parent',
      imagePath: null,
      productCount: 15,
      isActive: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CategoryModel> get _filteredCategories {
    final searchText =
        _searchController.text.trim().toLowerCase();

    return _categories.where((category) {
      final matchesSearch =
          category.name.toLowerCase().contains(searchText) ||
          category.slug.toLowerCase().contains(searchText) ||
          category.parentName
              .toLowerCase()
              .contains(searchText);

      final matchesStatus =
          _selectedStatus == 'All Status' ||
          (_selectedStatus == 'Active' &&
              category.isActive) ||
          (_selectedStatus == 'Inactive' &&
              !category.isActive);

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> _openAddCategory() async {
    final newCategory =
        await Navigator.push<CategoryModel>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddCategoryScreen(),
      ),
    );

    if (newCategory == null || !mounted) {
      return;
    }

    setState(() {
      _categories.add(newCategory);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${newCategory.name} added successfully',
        ),
      ),
    );
  }

  Future<void> _openEditCategory(
    CategoryModel category,
  ) async {
    final updatedCategory =
        await Navigator.push<CategoryModel>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddCategoryScreen(
          category: category,
        ),
      ),
    );

    if (updatedCategory == null || !mounted) {
      return;
    }

    final categoryIndex = _categories.indexWhere(
      (item) => item.id == updatedCategory.id,
    );

    if (categoryIndex == -1) {
      return;
    }

    setState(() {
      _categories[categoryIndex] = updatedCategory;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${updatedCategory.name} updated successfully',
        ),
      ),
    );
  }

  Future<void> _deleteCategory(
    CategoryModel category,
  ) async {
    final shouldDelete =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),

          title: const Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
              ),

              SizedBox(width: 10),

              Text('Delete Category'),
            ],
          ),

          content: Text(
            'Are you sure you want to delete '
            '"${category.name}"?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor:
                    Colors.white,
              ),

              child:
                  const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    setState(() {
      _categories.removeWhere(
        (item) => item.id == category.id,
      );
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          '${category.name} deleted successfully',
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = 'All Status';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F6F8),

      child: SafeArea(
        child: LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final isDesktop =
                constraints.maxWidth >= 850;

            return ListView(
              padding: EdgeInsets.all(
                isDesktop ? 25 : 15,
              ),

              children: [
                _buildPageHeader(
                  isDesktop,
                ),

                const SizedBox(
                  height: 22,
                ),

                _buildStatistics(
                  isDesktop,
                ),

                const SizedBox(
                  height: 20,
                ),

                _buildFilterCard(
                  isDesktop,
                ),

                const SizedBox(
                  height: 20,
                ),

                if (isDesktop)
                  CategoryTable(
                    categories:
                        _filteredCategories,

                    onEdit:
                        _openEditCategory,

                    onDelete:
                        _deleteCategory,
                  )
                else
                  _buildMobileCategories(),

                const SizedBox(
                  height: 30,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageHeader(
    bool isDesktop,
  ) {
    if (isDesktop) {
      return Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Categories',

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        AppColors.textDark,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Manage product categories and subcategories',

                  style: TextStyle(
                    fontSize: 14,
                    color:
                        AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton.icon(
            onPressed:
                _openAddCategory,

            icon: const Icon(
              Icons.add_rounded,
            ),

            label: const Text(
              'Add Category',
            ),

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primary,

              foregroundColor:
                  Colors.white,

              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 22,
                vertical: 17,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius
                        .circular(12),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        const Text(
          'Categories',

          style: TextStyle(
            fontSize: 25,
            fontWeight:
                FontWeight.w800,
            color:
                AppColors.textDark,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Manage product categories',

          style: TextStyle(
            fontSize: 13,
            color:
                AppColors.textGrey,
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,

          child:
              ElevatedButton.icon(
            onPressed:
                _openAddCategory,

            icon: const Icon(
              Icons.add_rounded,
            ),

            label: const Text(
              'Add Category',
            ),

            style:
                ElevatedButton
                    .styleFrom(
              backgroundColor:
                  AppColors.primary,

              foregroundColor:
                  Colors.white,

              padding:
                  const EdgeInsets
                      .symmetric(
                vertical: 16,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius
                        .circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(
    bool isDesktop,
  ) {
    final activeCount =
        _categories
            .where(
              (category) =>
                  category.isActive,
            )
            .length;

    final inactiveCount =
        _categories.length -
            activeCount;

    final subCategoryCount =
        _categories
            .where(
              (category) =>
                  category.parentName !=
                  'No Parent',
            )
            .length;

    final cards = [
      _statCard(
        title:
            'Total Categories',
        value:
            '${_categories.length}',
        icon:
            Icons.category_outlined,
      ),

      _statCard(
        title:
            'Active Categories',
        value:
            '$activeCount',
        icon:
            Icons
                .check_circle_outline,
      ),

      _statCard(
        title:
            'Sub Categories',
        value:
            '$subCategoryCount',
        icon:
            Icons
                .account_tree_outlined,
      ),

      _statCard(
        title:
            'Inactive',
        value:
            '$inactiveCount',
        icon:
            Icons
                .pause_circle_outline,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,

      physics:
          const NeverScrollableScrollPhysics(),

      itemCount:
          cards.length,

      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            isDesktop ? 4 : 2,

        crossAxisSpacing:
            12,

        mainAxisSpacing:
            12,

        childAspectRatio:
            isDesktop
                ? 2.1
                : 1.5,
      ),

      itemBuilder:
          (context, index) {
        return cards[index];
      },
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(15),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          15,
        ),

        border: Border.all(
          color:
              Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,

            decoration:
                BoxDecoration(
              color: AppColors
                  .primary
                  .withOpacity(
                    0.09,
                  ),

              borderRadius:
                  BorderRadius
                      .circular(
                11,
              ),
            ),

            child: Icon(
              icon,
              color:
                  AppColors.primary,
              size: 22,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  value,

                  style:
                      const TextStyle(
                    fontSize: 21,

                    fontWeight:
                        FontWeight
                            .w800,

                    color:
                        AppColors
                            .textDark,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  title,

                  maxLines: 1,

                  overflow:
                      TextOverflow
                          .ellipsis,

                  style:
                      const TextStyle(
                    fontSize: 11,

                    color:
                        AppColors
                            .textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard(
    bool isDesktop,
  ) {
    final searchField =
        TextField(
      controller:
          _searchController,

      onChanged: (_) {
        setState(() {});
      },

      decoration:
          InputDecoration(
        hintText:
            'Search categories...',

        prefixIcon:
            const Icon(
          Icons.search_rounded,
        ),

        suffixIcon:
            _searchController
                    .text
                    .isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      setState(
                        () {
                          _searchController
                              .clear();
                        },
                      );
                    },

                    icon:
                        const Icon(
                      Icons
                          .close_rounded,
                    ),
                  ),

        filled: true,

        fillColor:
            const Color(
          0xFFF8F8FA,
        ),

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius
                  .circular(11),

          borderSide:
              BorderSide.none,
        ),
      ),
    );

    final statusDropdown =
        Container(
      height: 55,

      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 12,
      ),

      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFF8F8FA,
        ),

        borderRadius:
            BorderRadius
                .circular(11),
      ),

      child:
          DropdownButtonHideUnderline(
        child:
            DropdownButton<
                String>(
          value:
              _selectedStatus,

          isExpanded:
              true,

          items:
              const [
            DropdownMenuItem(
              value:
                  'All Status',

              child: Text(
                'All Status',
              ),
            ),

            DropdownMenuItem(
              value:
                  'Active',

              child: Text(
                'Active',
              ),
            ),

            DropdownMenuItem(
              value:
                  'Inactive',

              child: Text(
                'Inactive',
              ),
            ),
          ],

          onChanged:
              (value) {
            if (value ==
                null) {
              return;
            }

            setState(
              () {
                _selectedStatus =
                    value;
              },
            );
          },
        ),
      ),
    );

    final clearButton =
        SizedBox(
      height: 52,

      child:
          OutlinedButton
              .icon(
        onPressed:
            _clearFilters,

        icon:
            const Icon(
          Icons
              .filter_alt_off_outlined,
        ),

        label:
            const Text(
          'Clear',
        ),

        style:
            OutlinedButton
                .styleFrom(
          foregroundColor:
              AppColors
                  .textDark,

          side:
              BorderSide(
            color: Colors
                .grey
                .shade300,
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius
                    .circular(
              11,
            ),
          ),
        ),
      ),
    );

    return Container(
      padding:
          const EdgeInsets.all(
        16,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius
                .circular(16),

        border:
            Border.all(
          color: Colors
              .grey
              .shade200,
        ),
      ),

      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  flex: 3,
                  child:
                      searchField,
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child:
                      statusDropdown,
                ),

                const SizedBox(
                  width: 12,
                ),

                clearButton,
              ],
            )
          : Column(
              children: [
                searchField,

                const SizedBox(
                  height: 12,
                ),

                Row(
                  children: [
                    Expanded(
                      child:
                          statusDropdown,
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child:
                          clearButton,
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildMobileCategories() {
    if (_filteredCategories.isEmpty) {
      return Container(
        height: 260,

        decoration:
            BoxDecoration(
          color:
              Colors.white,

          borderRadius:
              BorderRadius
                  .circular(16),

          border:
              Border.all(
            color: Colors
                .grey
                .shade200,
          ),
        ),

        child:
            const Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment
                    .center,

            children: [
              Icon(
                Icons
                    .category_outlined,

                size: 48,

                color:
                    AppColors
                        .textGrey,
              ),

              SizedBox(
                height: 12,
              ),

              Text(
                'No categories found',

                style:
                    TextStyle(
                  fontWeight:
                      FontWeight
                          .w700,

                  color:
                      AppColors
                          .textDark,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment
              .start,

      children: [
        Row(
          children: [
            const Text(
              'All Categories',

              style:
                  TextStyle(
                fontSize:
                    18,

                fontWeight:
                    FontWeight
                        .w800,

                color:
                    AppColors
                        .textDark,
              ),
            ),

            const Spacer(),

            Text(
              '${_filteredCategories.length} items',

              style:
                  const TextStyle(
                color:
                    AppColors
                        .textGrey,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 12,
        ),

        ..._filteredCategories
            .map(
          (
            category,
          ) {
            return Padding(
              padding:
                  const EdgeInsets
                      .only(
                bottom:
                    12,
              ),

              child:
                  CategoryMobileCard(
                category:
                    category,

                onEdit:
                    () {
                  _openEditCategory(
                    category,
                  );
                },

                onDelete:
                    () {
                  _deleteCategory(
                    category,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}