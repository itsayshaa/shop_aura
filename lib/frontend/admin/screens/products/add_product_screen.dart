import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/widgets/products/product_dropdown_field.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_dynamic_list.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_image_upload.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_measurement_section.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_section_card.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_text_field.dart';

import 'package:shop_aura/frontend/theme/app_colors.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() =>
      _AddProductScreenState();
}

class _AddProductScreenState
    extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController =
      TextEditingController();

  final _slugController =
      TextEditingController();

  final _shortDescriptionController =
      TextEditingController();

  final _descriptionController =
      TextEditingController();

  final _priceController =
      TextEditingController();

  final _discountPriceController =
      TextEditingController();

  final _costPriceController =
      TextEditingController();

  final _stockController =
      TextEditingController();

  final _skuController =
      TextEditingController();

  final _barcodeController =
      TextEditingController();

  final _measurementValueController =
      TextEditingController();

  String _selectedCategory =
      'Electronics';

  String _selectedBrand =
      'Samsung';

  String _selectedMeasurementType =
      'Weight';

  String _selectedMeasurementUnit =
      'g';

  bool _isActive = true;

  bool _freeDelivery = false;

  bool _cashOnDelivery = true;

  bool _returnAvailable = true;

  final List<String> _colors = [];

  final List<String> _sizes = [];

  final List<String> _features = [];

  final List<String> _tags = [];

  @override
  void dispose() {
    _nameController.dispose();

    _slugController.dispose();

    _shortDescriptionController.dispose();

    _descriptionController.dispose();

    _priceController.dispose();

    _discountPriceController.dispose();

    _costPriceController.dispose();

    _stockController.dispose();

    _skuController.dispose();

    _barcodeController.dispose();

    _measurementValueController.dispose();

    super.dispose();
  }

  void _addItem(
    List<String> list,
    String title,
  ) {
    final controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Add $title',
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText:
                  'Enter $title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final value =
                    controller.text
                        .trim();

                if (value.isNotEmpty) {
                  setState(() {
                    list.add(
                      value,
                    );
                  });
                }

                Navigator.pop(
                  dialogContext,
                );
              },
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    AppColors.primary,
                foregroundColor:
                    Colors.white,
              ),
              child: const Text(
                'Add',
              ),
            ),
          ],
        );
      },
    ).whenComplete(
      controller.dispose,
    );
  }

  void _saveProduct() {
    if (!_formKey
        .currentState!
        .validate()) {
      return;
    }

    final product =
        <String, dynamic>{
      'name':
          _nameController.text
              .trim(),

      'category':
          _selectedCategory,

      'brand':
          _selectedBrand,

      'price':
          double.tryParse(
            _priceController.text
                .trim(),
          ) ??
              0,

      'stock':
          int.tryParse(
            _stockController.text
                .trim(),
          ) ??
              0,

      'status':
          _isActive
              ? 'Active'
              : 'Inactive',

      'slug':
          _slugController.text
              .trim(),

      'shortDescription':
          _shortDescriptionController
              .text
              .trim(),

      'description':
          _descriptionController
              .text
              .trim(),

      'discountPrice':
          double.tryParse(
            _discountPriceController
                .text
                .trim(),
          ) ??
              0,

      'costPrice':
          double.tryParse(
            _costPriceController
                .text
                .trim(),
          ) ??
              0,

      'sku':
          _skuController.text
              .trim(),

      'barcode':
          _barcodeController.text
              .trim(),

      'colors':
          List<String>.from(
        _colors,
      ),

      'sizes':
          List<String>.from(
        _sizes,
      ),

      'features':
          List<String>.from(
        _features,
      ),

      'tags':
          List<String>.from(
        _tags,
      ),

      'measurementType':
          _selectedMeasurementType,

      'measurementValue':
          double.tryParse(
            _measurementValueController
                .text
                .trim(),
          ) ??
              0,

      'measurementUnit':
          _selectedMeasurementUnit,

      'freeDelivery':
          _freeDelivery,

      'cashOnDelivery':
          _cashOnDelivery,

      'returnAvailable':
          _returnAvailable,
    };

    Navigator.pop(
      context,
      product,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(
        0xFFF7F7F9,
      ),

      appBar: AppBar(
        backgroundColor:
            Colors.white,

        surfaceTintColor:
            Colors.white,

        elevation: 0,

        iconTheme:
            const IconThemeData(
          color:
              AppColors.textDark,
        ),

        title: const Text(
          'Add Product',
          style: TextStyle(
            color:
                AppColors.textDark,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child:
              SingleChildScrollView(
            padding:
                const EdgeInsets.all(
              24,
            ),

            child: Center(
              child:
                  ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth:
                      1100,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    const Text(
                      'Add New Product',

                      style:
                          TextStyle(
                        fontSize:
                            28,

                        fontWeight:
                            FontWeight
                                .w700,

                        color:
                            AppColors
                                .textDark,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    const Text(
                      'Enter all product information below.',

                      style:
                          TextStyle(
                        color:
                            AppColors
                                .textGrey,
                      ),
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    _buildBasicInformation(),

                    const SizedBox(
                      height: 20,
                    ),

                    _buildDescription(),

                    const SizedBox(
                      height: 20,
                    ),

                    _buildPricing(),

                    const SizedBox(
                      height: 20,
                    ),

                    _buildInventory(),

                    const SizedBox(
                      height: 20,
                    ),

                    ProductMeasurementSection(
                      selectedType:
                          _selectedMeasurementType,

                      selectedUnit:
                          _selectedMeasurementUnit,

                      valueController:
                          _measurementValueController,

                      onTypeChanged:
                          (value) {
                        if (value ==
                            null) {
                          return;
                        }

                        setState(
                          () {
                            _selectedMeasurementType =
                                value;
                          },
                        );
                      },

                      onUnitChanged:
                          (value) {
                        if (value ==
                            null) {
                          return;
                        }

                        setState(
                          () {
                            _selectedMeasurementUnit =
                                value;
                          },
                        );
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    ProductImageUpload(
                      onTap: () {
                        ScaffoldMessenger
                            .of(
                          context,
                        )
                            .showSnackBar(
                          const SnackBar(
                            content:
                                Text(
                              'Image picker will be connected later',
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    ProductDynamicList(
                      title:
                          'Product Colors',

                      items:
                          _colors,

                      addText:
                          'Add Color',

                      onAdd: () {
                        _addItem(
                          _colors,
                          'Color',
                        );
                      },

                      onDelete:
                          (item) {
                        setState(
                          () {
                            _colors
                                .remove(
                              item,
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    ProductDynamicList(
                      title:
                          'Available Sizes',

                      items:
                          _sizes,

                      addText:
                          'Add Size',

                      onAdd: () {
                        _addItem(
                          _sizes,
                          'Size',
                        );
                      },

                      onDelete:
                          (item) {
                        setState(
                          () {
                            _sizes
                                .remove(
                              item,
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    ProductDynamicList(
                      title:
                          'Product Features',

                      items:
                          _features,

                      addText:
                          'Add Feature',

                      onAdd: () {
                        _addItem(
                          _features,
                          'Feature',
                        );
                      },

                      onDelete:
                          (item) {
                        setState(
                          () {
                            _features
                                .remove(
                              item,
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    ProductDynamicList(
                      title:
                          'Product Tags',

                      items:
                          _tags,

                      addText:
                          'Add Tag',

                      onAdd: () {
                        _addItem(
                          _tags,
                          'Tag',
                        );
                      },

                      onDelete:
                          (item) {
                        setState(
                          () {
                            _tags
                                .remove(
                              item,
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    _buildShipping(),

                    const SizedBox(
                      height: 20,
                    ),

                    _buildReturnSettings(),

                    const SizedBox(
                      height: 20,
                    ),

                    _buildStatus(),

                    const SizedBox(
                      height: 30,
                    ),

                    _buildButtons(),

                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget
      _buildBasicInformation() {
    return ProductSectionCard(
      title:
          'Basic Information',

      child: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          final isMobile =
              constraints
                      .maxWidth <
                  700;

          final width =
              isMobile
                  ? double.infinity
                  : (constraints
                              .maxWidth -
                          16) /
                      2;

          return Wrap(
            spacing: 16,
            runSpacing: 16,

            children: [
              ProductTextField(
                controller:
                    _nameController,

                label:
                    'Product Name',

                hint:
                    'Enter product name',

                width:
                    width,

                validator:
                    (value) {
                  if (value ==
                          null ||
                      value
                          .trim()
                          .isEmpty) {
                    return 'Product name is required';
                  }

                  return null;
                },
              ),

              ProductTextField(
                controller:
                    _slugController,

                label:
                    'Product Slug',

                hint:
                    'example-product-name',

                width:
                    width,
              ),

              ProductDropdownField(
                label:
                    'Category',

                value:
                    _selectedCategory,

                items:
                    const [
                  'Electronics',
                  'Fashion',
                  'Kitchen',
                  'Beauty',
                  'Books',
                  'Mobiles',
                ],

                width:
                    width,

                onChanged:
                    (value) {
                  if (value ==
                      null) {
                    return;
                  }

                  setState(
                    () {
                      _selectedCategory =
                          value;
                    },
                  );
                },
              ),

              ProductDropdownField(
                label:
                    'Brand',

                value:
                    _selectedBrand,

                items:
                    const [
                  'Samsung',
                  'Boat',
                  'Hawkins',
                  'Nike',
                  'Apple',
                ],

                width:
                    width,

                onChanged:
                    (value) {
                  if (value ==
                      null) {
                    return;
                  }

                  setState(
                    () {
                      _selectedBrand =
                          value;
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget
      _buildDescription() {
    return ProductSectionCard(
      title:
          'Product Description',

      child: Column(
        children: [
          ProductTextField(
            controller:
                _shortDescriptionController,

            label:
                'Short Description',

            hint:
                'Enter a short description',

            maxLines: 3,

            width:
                double.infinity,
          ),

          const SizedBox(
            height: 16,
          ),

          ProductTextField(
            controller:
                _descriptionController,

            label:
                'Full Description',

            hint:
                'Enter complete product details',

            maxLines: 6,

            width:
                double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildPricing() {
    return ProductSectionCard(
      title: 'Pricing',

      child: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          final isMobile =
              constraints
                      .maxWidth <
                  700;

          final width =
              isMobile
                  ? double.infinity
                  : (constraints
                              .maxWidth -
                          32) /
                      3;

          return Wrap(
            spacing: 16,
            runSpacing: 16,

            children: [
              ProductTextField(
                controller:
                    _priceController,

                label:
                    'Selling Price',

                hint:
                    '₹ 0',

                width:
                    width,

                keyboardType:
                    TextInputType
                        .number,

                validator:
                    (value) {
                  if (value ==
                          null ||
                      value
                          .trim()
                          .isEmpty) {
                    return 'Price is required';
                  }

                  if (double.tryParse(
                          value
                              .trim(),
                        ) ==
                      null) {
                    return 'Enter a valid price';
                  }

                  return null;
                },
              ),

              ProductTextField(
                controller:
                    _discountPriceController,

                label:
                    'Discount Price',

                hint:
                    '₹ 0',

                width:
                    width,

                keyboardType:
                    TextInputType
                        .number,
              ),

              ProductTextField(
                controller:
                    _costPriceController,

                label:
                    'Cost Price',

                hint:
                    '₹ 0',

                width:
                    width,

                keyboardType:
                    TextInputType
                        .number,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget
      _buildInventory() {
    return ProductSectionCard(
      title:
          'Inventory',

      child: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          final isMobile =
              constraints
                      .maxWidth <
                  700;

          final width =
              isMobile
                  ? double.infinity
                  : (constraints
                              .maxWidth -
                          32) /
                      3;

          return Wrap(
            spacing: 16,
            runSpacing: 16,

            children: [
              ProductTextField(
                controller:
                    _stockController,

                label:
                    'Stock Quantity',

                hint:
                    '0',

                width:
                    width,

                keyboardType:
                    TextInputType
                        .number,

                validator:
                    (value) {
                  if (value ==
                          null ||
                      value
                          .trim()
                          .isEmpty) {
                    return 'Stock is required';
                  }

                  if (int.tryParse(
                          value
                              .trim(),
                        ) ==
                      null) {
                    return 'Enter a valid stock';
                  }

                  return null;
                },
              ),

              ProductTextField(
                controller:
                    _skuController,

                label:
                    'SKU',

                hint:
                    'Product SKU',

                width:
                    width,
              ),

              ProductTextField(
                controller:
                    _barcodeController,

                label:
                    'Barcode',

                hint:
                    'Product barcode',

                width:
                    width,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget
      _buildShipping() {
    return ProductSectionCard(
      title:
          'Shipping & Delivery',

      child: Column(
        children: [
          SwitchListTile(
            contentPadding:
                EdgeInsets.zero,

            title:
                const Text(
              'Free Delivery',
            ),

            value:
                _freeDelivery,

            activeColor:
                AppColors.primary,

            onChanged:
                (value) {
              setState(
                () {
                  _freeDelivery =
                      value;
                },
              );
            },
          ),

          SwitchListTile(
            contentPadding:
                EdgeInsets.zero,

            title:
                const Text(
              'Cash on Delivery',
            ),

            value:
                _cashOnDelivery,

            activeColor:
                AppColors.primary,

            onChanged:
                (value) {
              setState(
                () {
                  _cashOnDelivery =
                      value;
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget
      _buildReturnSettings() {
    return ProductSectionCard(
      title:
          'Return Settings',

      child:
          SwitchListTile(
        contentPadding:
            EdgeInsets.zero,

        title:
            const Text(
          'Return Available',
        ),

        value:
            _returnAvailable,

        activeColor:
            AppColors.primary,

        onChanged:
            (value) {
          setState(
            () {
              _returnAvailable =
                  value;
            },
          );
        },
      ),
    );
  }

  Widget _buildStatus() {
    return ProductSectionCard(
      title:
          'Product Status',

      child:
          SwitchListTile(
        contentPadding:
            EdgeInsets.zero,

        title:
            const Text(
          'Product is Active',
        ),

        value:
            _isActive,

        activeColor:
            AppColors.primary,

        onChanged:
            (value) {
          setState(
            () {
              _isActive =
                  value;
            },
          );
        },
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.end,

      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },

          style:
              OutlinedButton
                  .styleFrom(
            foregroundColor:
                AppColors
                    .textDark,

            padding:
                const EdgeInsets
                    .symmetric(
              horizontal:
                  25,

              vertical:
                  17,
            ),

            side:
                BorderSide(
              color:
                  Colors
                      .grey
                      .shade400,
            ),
          ),

          child:
              const Text(
            'Cancel',
          ),
        ),

        const SizedBox(
          width: 15,
        ),

        ElevatedButton.icon(
          onPressed:
              _saveProduct,

          icon:
              const Icon(
            Icons
                .save_rounded,
          ),

          label:
              const Text(
            'Save Product',
          ),

          style:
              ElevatedButton
                  .styleFrom(
            backgroundColor:
                AppColors
                    .primary,

            foregroundColor:
                Colors.white,

            elevation: 0,

            padding:
                const EdgeInsets
                    .symmetric(
              horizontal:
                  25,

              vertical:
                  17,
            ),

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius
                      .circular(
                10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}