import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class AddBannerScreen extends StatefulWidget {
  const AddBannerScreen({super.key});

  @override
  State<AddBannerScreen> createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController buttonTextController =
      TextEditingController(text: 'Shop Now');

  final TextEditingController linkController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  File? selectedImage;

  String selectedLocation = 'Home Page';
  String selectedBannerType = 'Main Banner';

  bool isActive = true;

  final List<String> bannerLocations = [
    'Home Page',
    'Categories Page',
    'Products Page',
    'Product Details Page',
  ];

  final List<String> bannerTypes = [
    'Main Banner',
    'Promotional Banner',
    'Offer Banner',
    'Category Banner',
    'Product Banner',
  ];

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    buttonTextController.dispose();
    linkController.dispose();

    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
    });
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Select Banner Image',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Choose an image from the camera or gallery',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: _imageOption(
                        icon: Icons.camera_alt_outlined,
                        title: 'Camera',
                        onTap: () async {
                          Navigator.pop(context);

                          await _pickImage(
                            ImageSource.camera,
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: _imageOption(
                        icon: Icons.photo_library_outlined,
                        title: 'Gallery',
                        onTap: () async {
                          Navigator.pop(context);

                          await _pickImage(
                            ImageSource.gallery,
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(.15),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: AppColors.primary,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveBanner() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a banner image',
          ),
        ),
      );

      return;
    }

    // Backend API connection will be added later.
    // For now, this validates the form.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Banner saved successfully',
        ),
      ),
    );

    Navigator.pop(context);
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      prefixIcon: icon == null
          ? null
          : Icon(
              icon,
              color: AppColors.primary,
            ),

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.primary,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Add Banner',
        ),

        centerTitle: true,

        backgroundColor: Colors.white,

        foregroundColor: AppColors.textDark,

        elevation: 0,

        surfaceTintColor: Colors.white,
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              16,
              18,
              16,
              35,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                _sectionTitle(
                  'Banner Image',
                  'Upload the image that will be shown to customers',
                ),

                const SizedBox(height: 14),

                InkWell(
                  onTap: _showImagePicker,

                  borderRadius: BorderRadius.circular(20),

                  child: Container(
                    width: double.infinity,
                    height: 205,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(20),

                      border: Border.all(
                        color: selectedImage == null
                            ? Colors.grey.shade300
                            : AppColors.primary,
                        width: selectedImage == null
                            ? 1
                            : 1.5,
                      ),
                    ),

                    child: selectedImage == null
                        ? Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [
                              Container(
                                width: 62,
                                height: 62,

                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withOpacity(.10),

                                  shape: BoxShape.circle,
                                ),

                                child: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 30,
                                  color: AppColors.primary,
                                ),
                              ),

                              const SizedBox(height: 13),

                              const Text(
                                'Upload Banner Image',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                'Camera or Gallery',
                                style: TextStyle(
                                  color:
                                      Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(19),

                            child: Stack(
                              fit: StackFit.expand,

                              children: [
                                Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),

                                Positioned(
                                  top: 10,
                                  right: 10,

                                  child: Container(
                                    decoration:
                                        const BoxDecoration(
                                      color: Colors.white,
                                      shape:
                                          BoxShape.circle,
                                    ),

                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedImage =
                                              null;
                                        });
                                      },

                                      icon: const Icon(
                                        Icons.close,
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: 10,
                                  right: 10,

                                  child: ElevatedButton.icon(
                                    onPressed:
                                        _showImagePicker,

                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                    ),

                                    label: const Text(
                                      'Change',
                                    ),

                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.white,

                                      foregroundColor:
                                          AppColors.primary,

                                      elevation: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 28),

                _sectionTitle(
                  'Banner Details',
                  'Add the content displayed on the banner',
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: titleController,

                  decoration: _inputDecoration(
                    label: 'Banner Title',
                    hint: 'Example: Summer Collection',
                    icon: Icons.title_outlined,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Banner title is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: subtitleController,

                  maxLines: 3,

                  decoration: _inputDecoration(
                    label: 'Banner Description',
                    hint:
                        'Example: Get up to 50% off on selected products',
                    icon: Icons.description_outlined,
                  ),
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: buttonTextController,

                  decoration: _inputDecoration(
                    label: 'Button Text',
                    hint: 'Example: Shop Now',
                    icon: Icons.smart_button_outlined,
                  ),
                ),

                const SizedBox(height: 28),

                _sectionTitle(
                  'Banner Placement',
                  'Choose where this banner should appear',
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: selectedLocation,

                  decoration: _inputDecoration(
                    label: 'Display Location',
                    hint: 'Select page',
                    icon: Icons.location_on_outlined,
                  ),

                  items: bannerLocations
                      .map(
                        (location) =>
                            DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        ),
                      )
                      .toList(),

                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedLocation = value;
                    });
                  },
                ),

                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  value: selectedBannerType,

                  decoration: _inputDecoration(
                    label: 'Banner Type',
                    hint: 'Select banner type',
                    icon: Icons.view_carousel_outlined,
                  ),

                  items: bannerTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ),
                      )
                      .toList(),

                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedBannerType = value;
                    });
                  },
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: linkController,

                  decoration: _inputDecoration(
                    label: 'Banner Action / Link',
                    hint:
                        'Example: Fashion category or product ID',
                    icon: Icons.link_outlined,
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(15),

                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),

                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,

                    title: const Text(
                      'Active Banner',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    subtitle: Text(
                      isActive
                          ? 'This banner is visible to customers'
                          : 'This banner is hidden from customers',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            Colors.grey.shade600,
                      ),
                    ),

                    value: isActive,

                    activeColor:
                        AppColors.primary,

                    onChanged: (value) {
                      setState(() {
                        isActive = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: ElevatedButton.icon(
                    onPressed: _saveBanner,

                    icon: const Icon(
                      Icons.save_outlined,
                    ),

                    label: const Text(
                      'Save Banner',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primary,

                      foregroundColor:
                          Colors.white,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
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