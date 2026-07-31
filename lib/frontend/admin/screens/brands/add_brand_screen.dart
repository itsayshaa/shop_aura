import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/models/brand_model.dart';
import 'package:shop_aura/frontend/admin/widgets/brands/brand_form_actions.dart';
import 'package:shop_aura/frontend/admin/widgets/brands/brand_form_section.dart';
import 'package:shop_aura/frontend/admin/widgets/brands/brand_image_picker.dart';
import 'package:shop_aura/frontend/admin/widgets/brands/brand_status_switch.dart';
import 'package:shop_aura/frontend/admin/widgets/brands/brand_text_field.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class AddBrandScreen extends StatefulWidget {
  final BrandModel? brand;

  const AddBrandScreen({
    super.key,
    this.brand,
  });

  @override
  State<AddBrandScreen> createState() =>
      _AddBrandScreenState();
}

class _AddBrandScreenState
    extends State<AddBrandScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController
      _nameController;

  late final TextEditingController
      _slugController;

  late final TextEditingController
      _descriptionController;

  bool _isActive = true;

  bool get _isEditing =>
      widget.brand != null;

  @override
  void initState() {
    super.initState();

    final brand = widget.brand;

    _nameController =
        TextEditingController(
      text: brand?.name ?? '',
    );

    _slugController =
        TextEditingController(
      text: brand?.slug ?? '',
    );

    _descriptionController =
        TextEditingController(
      text: brand?.description ?? '',
    );

    _isActive =
        brand?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void _generateSlug(
    String value,
  ) {
    final slug = value
        .toLowerCase()
        .trim()
        .replaceAll(
          RegExp(r'[^a-z0-9]+'),
          '-',
        )
        .replaceAll(
          RegExp(r'^-+|-+$'),
          '',
        );

    _slugController.value =
        TextEditingValue(
      text: slug,
      selection:
          TextSelection.collapsed(
        offset: slug.length,
      ),
    );
  }

  void _saveBrand() {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? 'Brand updated successfully'
              : 'Brand saved successfully',
        ),
        backgroundColor:
            AppColors.primary,
      ),
    );

    Navigator.pop(context);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: _cancel,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                ),
                label: const Text(
                  'Back',
                ),
                style:
                    TextButton.styleFrom(
                  foregroundColor:
                      AppColors.textGrey,
                  padding:
                      EdgeInsets.zero,
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              Text(
                _isEditing
                    ? 'Edit Brand'
                    : 'Add Brand',
                style:
                    const TextStyle(
                  fontSize: 34,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      AppColors.textDark,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(
                _isEditing
                    ? 'Update your product brand'
                    : 'Create a new product brand',
                style:
                    const TextStyle(
                  fontSize: 16,
                  color:
                      AppColors.textGrey,
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              LayoutBuilder(
                builder: (
                  context,
                  constraints,
                ) {
                  final isMobile =
                      constraints
                              .maxWidth <
                          850;

                  if (isMobile) {
                    return Column(
                      children: [
                        _buildBrandDetails(),

                        const SizedBox(
                          height: 18,
                        ),

                        _buildSideSection(),

                        const SizedBox(
                          height: 18,
                        ),

                        _buildActions(),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Expanded(
                        flex: 3,
                        child:
                            _buildBrandDetails(),
                      ),

                      const SizedBox(
                        width: 24,
                      ),

                      Expanded(
                        flex: 2,
                        child:
                            _buildSideSection(),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(
                height: 18,
              ),

              LayoutBuilder(
                builder: (
                  context,
                  constraints,
                ) {
                  if (constraints
                          .maxWidth <
                      850) {
                    return const SizedBox();
                  }

                  return Align(
                    alignment:
                        Alignment
                            .centerRight,
                    child:
                        _buildActions(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandDetails() {
    return BrandFormSection(
      title: 'Brand Details',
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          BrandTextField(
            label: 'Brand Name *',
            hintText:
                'Enter brand name',
            controller:
                _nameController,
            onChanged:
                _generateSlug,
            validator: (
              value,
            ) {
              if (value == null ||
                  value
                      .trim()
                      .isEmpty) {
                return 'Please enter the brand name';
              }

              return null;
            },
          ),

          const SizedBox(
            height: 18,
          ),

          BrandTextField(
            label: 'Slug',
            hintText:
                'brand-slug',
            controller:
                _slugController,
            validator: (
              value,
            ) {
              if (value == null ||
                  value
                      .trim()
                      .isEmpty) {
                return 'Please enter the slug';
              }

              return null;
            },
          ),

          const SizedBox(
            height: 18,
          ),

          BrandTextField(
            label: 'Description',
            hintText:
                'Brand description...',
            controller:
                _descriptionController,
            maxLines: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildSideSection() {
    return Column(
      children: [
        BrandImagePicker(
          title: 'Brand Logo',
          imagePath:
              widget.brand?.logoPath,
        ),

        const SizedBox(
          height: 18,
        ),

        BrandStatusSwitch(
          isActive: _isActive,
          onChanged: (
            value,
          ) {
            setState(() {
              _isActive = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildActions() {
    return BrandFormActions(
      saveText: _isEditing
          ? 'Update Brand'
          : 'Save Brand',
      onCancel: _cancel,
      onSave: _saveBrand,
    );
  }
}