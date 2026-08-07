import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shop_aura/frontend/admin/models/admin_banner_model.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class EditBannerScreen extends StatefulWidget {
  final AdminBannerModel banner;

  const EditBannerScreen({
    super.key,
    required this.banner,
  });

  @override
  State<EditBannerScreen> createState() =>
      _EditBannerScreenState();
}

class _EditBannerScreenState
    extends State<EditBannerScreen> {
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _imagePicker = ImagePicker();

  late final TextEditingController _titleController;

  late final TextEditingController _subtitleController;

  late final TextEditingController _buttonTextController;

  late final TextEditingController _linkController;

  File? _selectedImage;

  late String _selectedLocation;

  String _selectedBannerType = 'Main Banner';

  late bool _isActive;

  late int _displayOrder;

  final List<String> _bannerLocations = [
    'Home Page',
    'Categories Page',
    'Products Page',
    'Product Details Page',
  ];

  final List<String> _bannerTypes = [
    'Main Banner',
    'Promotional Banner',
    'Offer Banner',
    'Category Banner',
    'Product Banner',
  ];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.banner.title,
    );

    _subtitleController = TextEditingController();

    _buttonTextController =
        TextEditingController(
      text: 'Shop Now',
    );

    _linkController = TextEditingController();

    _selectedLocation =
        widget.banner.location;

    _isActive =
        widget.banner.isActive;

    _displayOrder =
        widget.banner.displayOrder;
  }

  @override
  void dispose() {
    _titleController.dispose();

    _subtitleController.dispose();

    _buttonTextController.dispose();

    _linkController.dispose();

    super.dispose();
  }

  Future<void> _pickImage(
    ImageSource source,
  ) async {
    final XFile? image =
        await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (image == null) {
      return;
    }

    setState(() {
      _selectedImage =
          File(image.path);
    });
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent,
      builder: (context) {
        return Container(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            15,
            20,
            25,
          ),

          decoration:
              const BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.vertical(
              top: Radius.circular(
                25,
              ),
            ),
          ),

          child: SafeArea(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                Container(
                  width: 45,
                  height: 5,

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.grey.shade300,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                const Text(
                  'Change Banner Image',

                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  'Choose a new image from '
                  'your camera or gallery',

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(
                    color:
                        Colors.grey.shade600,

                    fontSize: 13,
                  ),
                ),

                const SizedBox(
                  height: 22,
                ),

                Row(
                  children: [
                    Expanded(
                      child:
                          _imageOption(
                        icon: Icons
                            .camera_alt_outlined,

                        title:
                            'Camera',

                        onTap:
                            () async {
                          Navigator.pop(
                            context,
                          );

                          await _pickImage(
                            ImageSource
                                .camera,
                          );
                        },
                      ),
                    ),

                    const SizedBox(
                      width: 14,
                    ),

                    Expanded(
                      child:
                          _imageOption(
                        icon: Icons
                            .photo_library_outlined,

                        title:
                            'Gallery',

                        onTap:
                            () async {
                          Navigator.pop(
                            context,
                          );

                          await _pickImage(
                            ImageSource
                                .gallery,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _imageOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(
        16,
      ),

      child: Container(
        padding:
            const EdgeInsets.symmetric(
          vertical: 20,
        ),

        decoration:
            BoxDecoration(
          color:
              AppColors.background,

          borderRadius:
              BorderRadius.circular(
            16,
          ),

          border:
              Border.all(
            color:
                AppColors.primary
                    .withOpacity(
              .15,
            ),
          ),
        ),

        child: Column(
          children: [
            Icon(
              icon,

              size: 30,

              color:
                  AppColors.primary,
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              title,

              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateBanner() {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final updatedBanner =
        widget.banner.copyWith(
      title:
          _titleController.text
              .trim(),

      location:
          _selectedLocation,

      displayOrder:
          _displayOrder,

      isActive:
          _isActive,

      // The local image path is returned
      // temporarily. Later, the backend
      // will upload the image and return
      // a MongoDB/API image URL.
      imageUrl:
          _selectedImage?.path ??
              widget.banner.imageUrl,
    );

    Navigator.pop(
      context,
      updatedBanner,
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,

      hintText: hint,

      prefixIcon:
          icon == null
              ? null
              : Icon(
                  icon,

                  color:
                      AppColors.primary,
                ),

      filled: true,

      fillColor:
          Colors.white,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          14,
        ),

        borderSide:
            BorderSide(
          color:
              Colors.grey.shade300,
        ),
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          14,
        ),

        borderSide:
            BorderSide(
          color:
              Colors.grey.shade300,
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          14,
        ),

        borderSide:
            BorderSide(
          color:
              AppColors.primary,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _sectionTitle(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style:
              const TextStyle(
            fontSize: 17,

            fontWeight:
                FontWeight.w800,
          ),
        ),

        const SizedBox(
          height: 4,
        ),

        Text(
          subtitle,

          style:
              TextStyle(
            color:
                Colors.grey.shade600,

            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return InkWell(
      onTap:
          _showImagePicker,

      borderRadius:
          BorderRadius.circular(
        20,
      ),

      child: Container(
        width:
            double.infinity,

        height: 210,

        clipBehavior:
            Clip.antiAlias,

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
                AppColors.primary
                    .withOpacity(
              .30,
            ),
          ),
        ),

        child: Stack(
          fit:
              StackFit.expand,

          children: [
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,

                fit:
                    BoxFit.cover,
              )
            else
              Image.network(
                widget
                    .banner
                    .imageUrl,

                fit:
                    BoxFit.cover,

                errorBuilder:
                    (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    color:
                        const Color(
                      0xFFF1F1F1,
                    ),

                    child:
                        const Center(
                      child:
                          Icon(
                        Icons
                            .image_not_supported_outlined,

                        size:
                            45,
                      ),
                    ),
                  );
                },
              ),

            Container(
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  begin:
                      Alignment
                          .bottomCenter,

                  end:
                      Alignment
                          .center,

                  colors: [
                    Colors.black
                        .withOpacity(
                      .55,
                    ),

                    Colors
                        .transparent,
                  ],
                ),
              ),
            ),

            Positioned(
              left: 14,
              bottom: 14,

              child:
                  Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal:
                      13,

                  vertical:
                      9,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      Colors.white,

                  borderRadius:
                      BorderRadius
                          .circular(
                    25,
                  ),
                ),

                child:
                    Row(
                  mainAxisSize:
                      MainAxisSize
                          .min,

                  children: [
                    Icon(
                      Icons
                          .edit_outlined,

                      size:
                          18,

                      color:
                          AppColors
                              .primary,
                    ),

                    const SizedBox(
                      width:
                          7,
                    ),

                    Text(
                      'Change Image',

                      style:
                          TextStyle(
                        color:
                            AppColors
                                .primary,

                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_selectedImage !=
                null)
              Positioned(
                top: 12,
                right: 12,

                child:
                    IconButton(
                  onPressed:
                      () {
                    setState(
                      () {
                        _selectedImage =
                            null;
                      },
                    );
                  },

                  style:
                      IconButton
                          .styleFrom(
                    backgroundColor:
                        Colors.white,
                  ),

                  icon:
                      const Icon(
                    Icons.close,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar:
          AppBar(
        title:
            const Text(
          'Edit Banner',
        ),

        centerTitle:
            true,

        backgroundColor:
            Colors.white,

        foregroundColor:
            AppColors.textDark,

        surfaceTintColor:
            Colors.white,

        elevation:
            0,

        actions: [
          IconButton(
            onPressed:
                () {
              _updateBanner();
            },

            icon:
                const Icon(
              Icons
                  .check_rounded,
            ),
          ),
        ],
      ),

      body:
          SafeArea(
        child:
            Form(
          key:
              _formKey,

          child:
              SingleChildScrollView(
            padding:
                const EdgeInsets
                    .fromLTRB(
              16,
              18,
              16,
              35,
            ),

            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                _sectionTitle(
                  'Banner Image',

                  'Update the image displayed '
                  'to customers',
                ),

                const SizedBox(
                  height:
                      14,
                ),

                _buildImagePreview(),

                const SizedBox(
                  height:
                      28,
                ),

                _sectionTitle(
                  'Banner Details',

                  'Update banner content',
                ),

                const SizedBox(
                  height:
                      15,
                ),

                TextFormField(
                  controller:
                      _titleController,

                  decoration:
                      _inputDecoration(
                    label:
                        'Banner Title',

                    hint:
                        'Enter banner title',

                    icon:
                        Icons
                            .title_outlined,
                  ),

                  validator:
                      (
                    value,
                  ) {
                    if (value ==
                            null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Banner title is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height:
                      14,
                ),

                TextFormField(
                  controller:
                      _subtitleController,

                  maxLines:
                      3,

                  decoration:
                      _inputDecoration(
                    label:
                        'Banner Description',

                    hint:
                        'Enter banner description',

                    icon:
                        Icons
                            .description_outlined,
                  ),
                ),

                const SizedBox(
                  height:
                      14,
                ),

                TextFormField(
                  controller:
                      _buttonTextController,

                  decoration:
                      _inputDecoration(
                    label:
                        'Button Text',

                    hint:
                        'Example: Shop Now',

                    icon:
                        Icons
                            .smart_button_outlined,
                  ),
                ),

                const SizedBox(
                  height:
                      28,
                ),

                _sectionTitle(
                  'Banner Placement',

                  'Choose where the banner '
                  'will appear',
                ),

                const SizedBox(
                  height:
                      15,
                ),

                DropdownButtonFormField<
                    String>(
                  value:
                      _selectedLocation,

                  decoration:
                      _inputDecoration(
                    label:
                        'Display Location',

                    hint:
                        'Select page',

                    icon:
                        Icons
                            .location_on_outlined,
                  ),

                  items:
                      _bannerLocations
                          .map(
                    (
                      location,
                    ) {
                      return DropdownMenuItem<
                          String>(
                        value:
                            location,

                        child:
                            Text(
                          location,
                        ),
                      );
                    },
                  ).toList(),

                  onChanged:
                      (
                    value,
                  ) {
                    if (value ==
                        null) {
                      return;
                    }

                    setState(
                      () {
                        _selectedLocation =
                            value;
                      },
                    );
                  },
                ),

                const SizedBox(
                  height:
                      14,
                ),

                DropdownButtonFormField<
                    String>(
                  value:
                      _selectedBannerType,

                  decoration:
                      _inputDecoration(
                    label:
                        'Banner Type',

                    hint:
                        'Select banner type',

                    icon:
                        Icons
                            .view_carousel_outlined,
                  ),

                  items:
                      _bannerTypes
                          .map(
                    (
                      type,
                    ) {
                      return DropdownMenuItem<
                          String>(
                        value:
                            type,

                        child:
                            Text(
                          type,
                        ),
                      );
                    },
                  ).toList(),

                  onChanged:
                      (
                    value,
                  ) {
                    if (value ==
                        null) {
                      return;
                    }

                    setState(
                      () {
                        _selectedBannerType =
                            value;
                      },
                    );
                  },
                ),

                const SizedBox(
                  height:
                      14,
                ),

                TextFormField(
                  controller:
                      _linkController,

                  decoration:
                      _inputDecoration(
                    label:
                        'Banner Action / Link',

                    hint:
                        'Category, product or '
                        'destination ID',

                    icon:
                        Icons
                            .link_outlined,
                  ),
                ),

                const SizedBox(
                  height:
                      20,
                ),

                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal:
                        16,

                    vertical:
                        7,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,

                    borderRadius:
                        BorderRadius
                            .circular(
                      15,
                    ),

                    border:
                        Border.all(
                      color:
                          Colors
                              .grey
                              .shade200,
                    ),
                  ),

                  child:
                      SwitchListTile(
                    contentPadding:
                        EdgeInsets
                            .zero,

                    title:
                        const Text(
                      'Active Banner',

                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),

                    subtitle:
                        Text(
                      _isActive
                          ? 'Visible to customers'
                          : 'Hidden from customers',

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

                    value:
                        _isActive,

                    activeColor:
                        AppColors
                            .primary,

                    onChanged:
                        (
                      value,
                    ) {
                      setState(
                        () {
                          _isActive =
                              value;
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height:
                      30,
                ),

                SizedBox(
                  width:
                      double
                          .infinity,

                  height:
                      54,

                  child:
                      ElevatedButton
                          .icon(
                    onPressed:
                        _updateBanner,

                    icon:
                        const Icon(
                      Icons
                          .save_outlined,
                    ),

                    label:
                        const Text(
                      'Update Banner',

                      style:
                          TextStyle(
                        fontSize:
                            16,

                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),

                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          AppColors
                              .primary,

                      foregroundColor:
                          Colors
                              .white,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}