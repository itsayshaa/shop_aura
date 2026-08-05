import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/models/category_model.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_dropdown_field.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_form_actions.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_form_section.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_image_picker.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_status_switch.dart';
import 'package:shop_aura/frontend/admin/widgets/categories/category_text_field.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class AddCategoryScreen extends StatefulWidget {
  final CategoryModel? category;

  const AddCategoryScreen({
    super.key,
    this.category,
  });

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _slugController;
  late final TextEditingController _descriptionController;

  String? _selectedParentCategory;
  String _selectedCategoryType = 'Main Category';

  String? _imagePath;

  bool _isActive = true;
  bool _isSaving = false;

  final List<String> _parentCategories = const [
    'Electronics',
    'Fashion',
    'Beauty',
    'Home & Kitchen',
    'Books',
    'Sports',
  ];

  final List<String> _categoryTypes = const [
    'Main Category',
    'Sub Category',
  ];

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();

    final category = widget.category;

    _nameController = TextEditingController(
      text: category?.name ?? '',
    );

    _slugController = TextEditingController(
      text: category?.slug ?? '',
    );

    _descriptionController = TextEditingController(
      text: category?.description ?? '',
    );

    _selectedParentCategory = category?.parentName;

    if (_selectedParentCategory != null &&
        !_parentCategories.contains(_selectedParentCategory)) {
      _selectedParentCategory = null;
    }

    _selectedCategoryType =
        _selectedParentCategory == null
            ? 'Main Category'
            : 'Sub Category';

    _imagePath = category?.imagePath;

    _isActive = category?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void _generateSlug(String value) {
    final slug = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');

    _slugController.value = TextEditingValue(
      text: slug,
      selection: TextSelection.collapsed(
        offset: slug.length,
      ),
    );
  }

  void _pickImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Category image picker will be connected next.',
        ),
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _imagePath = null;
    });
  }

  Future<void> _saveCategory() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryType == 'Sub Category' &&
        _selectedParentCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a parent category.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isSaving = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) {
      return;
    }

    final category = CategoryModel(
      id: widget.category?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      slug: _slugController.text.trim(),
      description: _descriptionController.text.trim(),
      parentName: _selectedCategoryType == 'Main Category'
          ? 'No Parent'
          : _selectedParentCategory ?? 'No Parent',
      imagePath: _imagePath,
      productCount: widget.category?.productCount ?? 0,
      isActive: _isActive,
    );

    setState(() {
      _isSaving = false;
    });

    Navigator.pop(context, category);
  }

  @override
  Widget build(BuildContext context) {
    final pageTitle = _isEditing
        ? 'Edit Category'
        : 'Add Category';

    final pageDescription = _isEditing
        ? 'Update the category information below.'
        : 'Create a new category for your store.';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,

        iconTheme: const IconThemeData(
          color: AppColors.textDark,
        ),

        title: Text(
          pageTitle,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1050,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      pageTitle,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      pageDescription,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey,
                      ),
                    ),

                    const SizedBox(height: 25),

                    CategoryFormSection(
                      title: 'Basic Information',
                      subtitle:
                          'Enter the main details for this category.',

                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile =
                              constraints.maxWidth < 700;

                          final fieldWidth = isMobile
                              ? double.infinity
                              : (constraints.maxWidth - 16) / 2;

                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,

                            children: [
                              SizedBox(
                                width: fieldWidth,

                                child: CategoryTextField(
                                  controller: _nameController,

                                  label: 'Category Name',

                                  hint:
                                      'Enter category name',

                                  prefixIcon:
                                      Icons.category_outlined,

                                  onChanged: _generateSlug,

                                  validator: (value) {
                                    if (value == null ||
                                        value
                                            .trim()
                                            .isEmpty) {
                                      return 'Category name is required';
                                    }

                                    return null;
                                  },
                                ),
                              ),

                              SizedBox(
                                width: fieldWidth,

                                child: CategoryTextField(
                                  controller: _slugController,

                                  label: 'Category Slug',

                                  hint:
                                      'example-category',

                                  prefixIcon:
                                      Icons.link_rounded,

                                  validator: (value) {
                                    if (value == null ||
                                        value
                                            .trim()
                                            .isEmpty) {
                                      return 'Category slug is required';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    CategoryFormSection(
                      title: 'Category Settings',
                      subtitle:
                          'Choose the category type and parent.',

                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile =
                              constraints.maxWidth < 700;

                          final fieldWidth = isMobile
                              ? double.infinity
                              : (constraints.maxWidth - 16) / 2;

                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,

                            children: [
                              SizedBox(
                                width: fieldWidth,

                                child:
                                    CategoryDropdownField(
                                  label:
                                      'Category Type',

                                  hint:
                                      'Select category type',

                                  value:
                                      _selectedCategoryType,

                                  items:
                                      _categoryTypes,

                                  prefixIcon:
                                      Icons
                                          .account_tree_outlined,

                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setState(() {
                                      _selectedCategoryType =
                                          value;

                                      if (value ==
                                          'Main Category') {
                                        _selectedParentCategory =
                                            null;
                                      }
                                    });
                                  },
                                ),
                              ),

                              if (_selectedCategoryType ==
                                  'Sub Category')
                                SizedBox(
                                  width: fieldWidth,

                                  child:
                                      CategoryDropdownField(
                                    label:
                                        'Parent Category',

                                    hint:
                                        'Select parent category',

                                    value:
                                        _selectedParentCategory,

                                    items:
                                        _parentCategories,

                                    prefixIcon:
                                        Icons
                                            .folder_outlined,

                                    validator: (value) {
                                      if (value == null ||
                                          value
                                              .trim()
                                              .isEmpty) {
                                        return 'Parent category is required';
                                      }

                                      return null;
                                    },

                                    onChanged: (value) {
                                      setState(() {
                                        _selectedParentCategory =
                                            value;
                                      });
                                    },
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    CategoryFormSection(
                      title: 'Category Description',
                      subtitle:
                          'Add a short description for this category.',

                      child: CategoryTextField(
                        controller:
                            _descriptionController,

                        label: 'Description',

                        hint:
                            'Enter category description',

                        prefixIcon:
                            Icons.description_outlined,

                        maxLines: 5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    CategoryFormSection(
                      title: 'Category Image',
                      subtitle:
                          'Upload an image to represent this category.',

                      child: CategoryImagePicker(
                        imagePath: _imagePath,

                        onPickImage: _pickImage,

                        onRemoveImage:
                            _imagePath == null
                                ? null
                                : _removeImage,
                      ),
                    ),

                    const SizedBox(height: 20),

                    CategoryFormSection(
                      title: 'Category Status',
                      subtitle:
                          'Control whether this category is visible.',

                      child: CategoryStatusSwitch(
                        isActive: _isActive,

                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    CategoryFormActions(
                      onCancel: () {
                        Navigator.pop(context);
                      },

                      onSave: _saveCategory,

                      isLoading: _isSaving,

                      saveButtonText: _isEditing
                          ? 'Update Category'
                          : 'Save Category',
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}