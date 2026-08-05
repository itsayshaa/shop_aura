import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/models/brand_model.dart';
import 'package:shop_aura/frontend/admin/widgets/brands/brand_action_buttons.dart';
import 'package:shop_aura/frontend/admin/widgets/brands/brand_status_badge.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class BrandTable extends StatelessWidget {
  final List<BrandModel> brands;

  final ValueChanged<BrandModel> onEdit;

  final ValueChanged<BrandModel> onDelete;

  const BrandTable({
    super.key,
    required this.brands,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (brands.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final tableWidth =
            constraints.maxWidth < 950
                ? 950.0
                : constraints.maxWidth;

        return Container(
          width:
              double.infinity,
          decoration:
              BoxDecoration(
            color:
                Colors.white,
            borderRadius:
                BorderRadius
                    .circular(
              18,
            ),
            border:
                Border.all(
              color:
                  Colors.grey
                      .shade200,
            ),
          ),
          child:
              ClipRRect(
            borderRadius:
                BorderRadius
                    .circular(
              18,
            ),
            child:
                SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal,
              child:
                  SizedBox(
                width:
                    tableWidth,
                child:
                    Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    _buildTableHeader(),

                    ...brands.map(
                      _buildBrandRow,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 62,
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 22,
      ),
      color:
          const Color(
        0xFFF9F9FA,
      ),
      child:
          const Row(
        children: [
          Expanded(
            flex: 3,
            child:
                _TableHeaderText(
              text:
                  'BRAND',
            ),
          ),

          Expanded(
            flex: 2,
            child:
                _TableHeaderText(
              text:
                  'SLUG',
            ),
          ),

          Expanded(
            flex: 3,
            child:
                _TableHeaderText(
              text:
                  'DESCRIPTION',
            ),
          ),

          Expanded(
            flex: 2,
            child:
                _TableHeaderText(
              text:
                  'STATUS',
            ),
          ),

          SizedBox(
            width: 125,
            child:
                _TableHeaderText(
              text:
                  'ACTIONS',
              textAlign:
                  TextAlign
                      .center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandRow(
    BrandModel brand,
  ) {
    return Container(
      height: 92,
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 22,
      ),
      decoration:
          BoxDecoration(
        border:
            Border(
          top:
              BorderSide(
            color:
                Colors.grey
                    .shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child:
                _buildBrandInfo(
              brand,
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              brand.slug,
              maxLines: 1,
              overflow:
                  TextOverflow
                      .ellipsis,
              style:
                  const TextStyle(
                fontSize: 13,
                color:
                    AppColors
                        .textGrey,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              brand
                      .description
                      .trim()
                      .isEmpty
                  ? 'No description'
                  : brand
                      .description,
              maxLines: 2,
              overflow:
                  TextOverflow
                      .ellipsis,
              style:
                  const TextStyle(
                fontSize: 13,
                height: 1.4,
                color:
                    AppColors
                        .textGrey,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child:
                Align(
              alignment:
                  Alignment
                      .centerLeft,
              child:
                  BrandStatusBadge(
                isActive:
                    brand
                        .isActive,
              ),
            ),
          ),

          SizedBox(
            width: 125,
            child:
                Center(
              child:
                  BrandActionButtons(
                onEdit:
                    () {
                  onEdit(
                    brand,
                  );
                },
                onDelete:
                    () {
                  onDelete(
                    brand,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandInfo(
    BrandModel brand,
  ) {
    final hasLogo =
        brand.logoPath !=
                null &&
            brand
                .logoPath!
                .trim()
                .isNotEmpty;

    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          clipBehavior:
              Clip.antiAlias,
          decoration:
              BoxDecoration(
            color:
                AppColors
                    .primary
                    .withOpacity(
              0.08,
            ),
            borderRadius:
                BorderRadius
                    .circular(
              14,
            ),
          ),
          child:
              hasLogo
                  ? Image
                      .network(
                      brand
                          .logoPath!,
                      fit:
                          BoxFit
                              .contain,
                      errorBuilder:
                          (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return _buildBrandIcon();
                      },
                    )
                  : _buildBrandIcon(),
        ),

        const SizedBox(
          width: 14,
        ),

        Expanded(
          child: Text(
            brand.name,
            maxLines: 1,
            overflow:
                TextOverflow
                    .ellipsis,
            style:
                const TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight
                      .w700,
              color:
                  AppColors
                      .textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandIcon() {
    return const Icon(
      Icons
          .storefront_outlined,
      size: 27,
      color:
          AppColors.primary,
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width:
          double.infinity,
      height: 280,
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius
                .circular(
          18,
        ),
        border:
            Border.all(
          color:
              Colors.grey
                  .shade200,
        ),
      ),
      child:
          const Column(
        mainAxisAlignment:
            MainAxisAlignment
                .center,
        children: [
          Icon(
            Icons
                .storefront_outlined,
            size: 55,
            color:
                AppColors
                    .textGrey,
          ),

          SizedBox(
            height: 15,
          ),

          Text(
            'No brands found',
            style:
                TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight
                      .w700,
              color:
                  AppColors
                      .textDark,
            ),
          ),

          SizedBox(
            height: 6,
          ),

          Text(
            'Try changing your search.',
            style:
                TextStyle(
              fontSize: 13,
              color:
                  AppColors
                      .textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeaderText
    extends StatelessWidget {
  final String text;

  final TextAlign textAlign;

  const _TableHeaderText({
    required this.text,
    this.textAlign =
        TextAlign.left,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Text(
      text,
      textAlign:
          textAlign,
      style:
          const TextStyle(
        fontSize: 11,
        fontWeight:
            FontWeight.w800,
        color:
            AppColors
                .textGrey,
        letterSpacing:
            0.7,
      ),
    );
  }
}