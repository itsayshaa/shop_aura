import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/models/admin_banner_model.dart';
import 'package:shop_aura/frontend/admin/screens/banners/add_banner_screen.dart';
import 'package:shop_aura/frontend/admin/screens/banners/edit_banner_screen.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class BannersScreen extends StatefulWidget {
  const BannersScreen({super.key});

  @override
  State<BannersScreen> createState() => _BannersScreenState();
}

class _BannersScreenState extends State<BannersScreen> {
  final List<AdminBannerModel> _banners = [
    AdminBannerModel(
      id: 'banner_1',
      title: 'Summer Collection',
      imageUrl:
          'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=1200',
      location: 'Home Page',
      displayOrder: 1,
      isActive: true,
      createdAt: DateTime.now(),
    ),
    AdminBannerModel(
      id: 'banner_2',
      title: 'Premium Footwear',
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200',
      location: 'Categories Page',
      displayOrder: 2,
      isActive: true,
      createdAt: DateTime.now(),
    ),
    AdminBannerModel(
      id: 'banner_3',
      title: 'Special Product Offer',
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1200',
      location: 'Products Page',
      displayOrder: 3,
      isActive: false,
      createdAt: DateTime.now(),
    ),
  ];

  String _selectedLocation = 'All';

  final List<String> _locations = [
    'All',
    'Home Page',
    'Categories Page',
    'Products Page',
    'Product Details Page',
  ];

  List<AdminBannerModel> get _filteredBanners {
    if (_selectedLocation == 'All') {
      return _banners;
    }

    return _banners
        .where(
          (banner) =>
              banner.location == _selectedLocation,
        )
        .toList();
  }

  Future<void> _openAddBanner() async {
    final AdminBannerModel? newBanner =
        await Navigator.push<AdminBannerModel>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddBannerScreen(),
      ),
    );

    if (newBanner == null) {
      return;
    }

    setState(() {
      _banners.add(newBanner);

      _banners.sort(
        (a, b) =>
            a.displayOrder.compareTo(
          b.displayOrder,
        ),
      );
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Banner added successfully'),
      ),
    );
  }

  Future<void> _openEditBanner(
    AdminBannerModel banner,
  ) async {
    final AdminBannerModel? updatedBanner =
        await Navigator.push<AdminBannerModel>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditBannerScreen(
          banner: banner,
        ),
      ),
    );

    if (updatedBanner == null) {
      return;
    }

    final index = _banners.indexWhere(
      (item) =>
          item.id == updatedBanner.id,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      _banners[index] = updatedBanner;

      _banners.sort(
        (a, b) =>
            a.displayOrder.compareTo(
          b.displayOrder,
        ),
      );
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Banner updated successfully'),
      ),
    );
  }

  Future<void> _deleteBanner(
    AdminBannerModel banner,
  ) async {
    final bool? shouldDelete =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text(
            'Delete Banner?',
          ),
          content:
              Text(
            'Are you sure you want to delete '
            '"${banner.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child:
                  const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
                foregroundColor:
                    Colors.white,
              ),
              child:
                  const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      _banners.removeWhere(
        (item) =>
            item.id == banner.id,
      );
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Banner deleted successfully'),
      ),
    );
  }

  void _changeBannerStatus(
    AdminBannerModel banner,
    bool value,
  ) {
    final index = _banners.indexWhere(
      (item) =>
          item.id == banner.id,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      _banners[index] =
          banner.copyWith(
        isActive: value,
      );
    });
  }

  Widget _buildLocationFilter() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection:
            Axis.horizontal,
        itemCount:
            _locations.length,
        separatorBuilder:
            (_, __) =>
                const SizedBox(
          width: 10,
        ),
        itemBuilder:
            (context, index) {
          final location =
              _locations[index];

          final isSelected =
              _selectedLocation ==
                  location;

          return ChoiceChip(
            label:
                Text(location),
            selected:
                isSelected,
            onSelected:
                (_) {
              setState(() {
                _selectedLocation =
                    location;
              });
            },
            selectedColor:
                AppColors.primary,
            backgroundColor:
                Colors.white,
            labelStyle:
                TextStyle(
              color:
                  isSelected
                      ? Colors.white
                      : AppColors
                          .textDark,
              fontWeight:
                  FontWeight
                      .w600,
            ),
            side:
                BorderSide(
              color:
                  isSelected
                      ? AppColors
                          .primary
                      : Colors
                          .grey
                          .shade300,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerImage(
    AdminBannerModel banner,
  ) {
    final bool isLocalImage =
        banner.imageUrl.startsWith('/');

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(
        16,
      ),
      child:
          isLocalImage
              ? Image.asset(
                  banner.imageUrl,
                  width: 120,
                  height: 95,
                  fit:
                      BoxFit.cover,
                  errorBuilder:
                      (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return _imageError();
                  },
                )
              : Image.network(
                  banner.imageUrl,
                  width: 120,
                  height: 95,
                  fit:
                      BoxFit.cover,
                  errorBuilder:
                      (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return _imageError();
                  },
                ),
    );
  }

  Widget _imageError() {
    return Container(
      width: 120,
      height: 95,
      color:
          Colors.grey.shade200,
      child:
          const Icon(
        Icons
            .image_not_supported_outlined,
      ),
    );
  }

  Widget _buildBannerCard(
    AdminBannerModel banner,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),
      padding:
          const EdgeInsets.all(
        12,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        border:
            Border.all(
          color:
              Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              .04,
            ),
            blurRadius:
                12,
            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child:
          Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              _buildBannerImage(
                banner,
              ),

              const SizedBox(
                width: 13,
              ),

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child:
                              Text(
                            banner.title,
                            maxLines:
                                2,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                const TextStyle(
                              fontSize:
                                  16,
                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                          ),
                        ),

                        PopupMenuButton<
                            String>(
                          onSelected:
                              (
                            value,
                          ) {
                            if (value ==
                                'edit') {
                              _openEditBanner(
                                banner,
                              );
                            }

                            if (value ==
                                'delete') {
                              _deleteBanner(
                                banner,
                              );
                            }
                          },
                          itemBuilder:
                              (
                            context,
                          ) {
                            return [
                              const PopupMenuItem(
                                value:
                                    'edit',
                                child:
                                    Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .edit_outlined,
                                    ),
                                    SizedBox(
                                      width:
                                          10,
                                    ),
                                    Text(
                                      'Edit',
                                    ),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value:
                                    'delete',
                                child:
                                    Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .delete_outline,
                                      color:
                                          Colors
                                              .red,
                                    ),
                                    SizedBox(
                                      width:
                                          10,
                                    ),
                                    Text(
                                      'Delete',
                                      style:
                                          TextStyle(
                                        color:
                                            Colors
                                                .red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ];
                          },
                        ),
                      ],
                    ),

                    const SizedBox(
                      height:
                          8,
                    ),

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal:
                            9,
                        vertical:
                            5,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            AppColors
                                .primary
                                .withOpacity(
                          .08,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),
                      ),
                      child:
                          Text(
                        banner.location,
                        style:
                            TextStyle(
                          fontSize:
                              11,
                          color:
                              AppColors
                                  .primary,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height:
                          8,
                    ),

                    Text(
                      'Display order: '
                      '${banner.displayOrder}',

                      style:
                          TextStyle(
                        fontSize:
                            12,
                        color:
                            Colors
                                .grey
                                .shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          Divider(
            color:
                Colors.grey.shade200,
          ),

          Row(
            children: [
              Icon(
                banner.isActive
                    ? Icons
                        .visibility_outlined
                    : Icons
                        .visibility_off_outlined,
                size: 18,
                color:
                    banner.isActive
                        ? Colors.green
                        : Colors.grey,
              ),

              const SizedBox(
                width: 8,
              ),

              Text(
                banner.isActive
                    ? 'Active'
                    : 'Inactive',
                style:
                    TextStyle(
                  fontWeight:
                      FontWeight
                          .w600,
                  color:
                      banner.isActive
                          ? Colors.green
                          : Colors.grey,
                ),
              ),

              const Spacer(),

              Switch(
                value:
                    banner.isActive,
                activeColor:
                    AppColors.primary,
                onChanged:
                    (
                  value,
                ) {
                  _changeBannerStatus(
                    banner,
                    value,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final filteredBanners =
        _filteredBanners;

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar:
          AppBar(
        title:
            const Text(
          'Banners',
        ),
        backgroundColor:
            Colors.white,
        foregroundColor:
            AppColors.textDark,
        surfaceTintColor:
            Colors.white,
        elevation:
            0,
      ),

      floatingActionButton:
          FloatingActionButton
              .extended(
        onPressed:
            _openAddBanner,
        backgroundColor:
            AppColors.primary,
        foregroundColor:
            Colors.white,
        icon:
            const Icon(
          Icons.add,
        ),
        label:
            const Text(
          'Add Banner',
        ),
      ),

      body:
          SafeArea(
        child:
            Padding(
          padding:
              const EdgeInsets
                  .fromLTRB(
            16,
            14,
            16,
            90,
          ),

          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [
              const Text(
                'Manage promotional banners',

                style:
                    TextStyle(
                  fontSize:
                      20,

                  fontWeight:
                      FontWeight
                          .w800,
                ),
              ),

              const SizedBox(
                height:
                    5,
              ),

              Text(
                'Create banners and control '
                'where they appear in the app.',

                style:
                    TextStyle(
                  fontSize:
                      13,

                  color:
                      Colors
                          .grey
                          .shade600,
                ),
              ),

              const SizedBox(
                height:
                    18,
              ),

              _buildLocationFilter(),

              const SizedBox(
                height:
                    18,
              ),

              Text(
                '${filteredBanners.length} '
                'banner${filteredBanners.length == 1 ? '' : 's'}',

                style:
                    TextStyle(
                  fontSize:
                      13,

                  fontWeight:
                      FontWeight
                          .w700,

                  color:
                      Colors
                          .grey
                          .shade700,
                ),
              ),

              const SizedBox(
                height:
                    10,
              ),

              Expanded(
                child:
                    filteredBanners
                            .isEmpty
                        ? Center(
                            child:
                                Column(
                              mainAxisSize:
                                  MainAxisSize
                                      .min,

                              children: [
                                Icon(
                                  Icons
                                      .image_outlined,

                                  size:
                                      65,

                                  color:
                                      Colors
                                          .grey
                                          .shade400,
                                ),

                                const SizedBox(
                                  height:
                                      14,
                                ),

                                const Text(
                                  'No banners found',

                                  style:
                                      TextStyle(
                                    fontSize:
                                        17,

                                    fontWeight:
                                        FontWeight
                                            .w700,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                      5,
                                ),

                                Text(
                                  'Add a new banner '
                                  'to display it here.',

                                  style:
                                      TextStyle(
                                    color:
                                        Colors
                                            .grey
                                            .shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            physics:
                                const BouncingScrollPhysics(),

                            itemCount:
                                filteredBanners
                                    .length,

                            itemBuilder:
                                (
                              context,
                              index,
                            ) {
                              return _buildBannerCard(
                                filteredBanners[
                                    index],
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}