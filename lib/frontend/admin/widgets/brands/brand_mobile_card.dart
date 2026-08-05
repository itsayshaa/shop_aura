import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/models/brand_model.dart';
import 'package:shop_aura/frontend/admin/widgets/brands/brand_action_buttons.dart';
import 'package:shop_aura/frontend/admin/widgets/brands/brand_status_badge.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class BrandMobileCard
    extends StatelessWidget {
  final BrandModel brand;

  final VoidCallback onEdit;

  final VoidCallback onDelete;

  const BrandMobileCard({
    super.key,
    required this.brand,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final hasLogo =
        brand.logoPath !=
                null &&
            brand
                .logoPath!
                .trim()
                .isNotEmpty;

    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        18,
      ),
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
          Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Container(
                width: 62,
                height: 62,
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
                    15,
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
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      brand.name,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight
                                .w700,
                        color:
                            AppColors
                                .textDark,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
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

                    const SizedBox(
                      height: 10,
                    ),

                    BrandStatusBadge(
                      isActive:
                          brand
                              .isActive,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 17,
          ),

          Divider(
            height: 1,
            color:
                Colors.grey
                    .shade200,
          ),

          const SizedBox(
            height: 15,
          ),

          const Text(
            'DESCRIPTION',
            style:
                TextStyle(
              fontSize: 11,
              fontWeight:
                  FontWeight
                      .w800,
              letterSpacing:
                  0.7,
              color:
                  AppColors
                      .textGrey,
            ),
          ),

          const SizedBox(
            height: 7,
          ),

          Text(
            brand
                    .description
                    .trim()
                    .isEmpty
                ? 'No description'
                : brand
                    .description,
            maxLines: 3,
            overflow:
                TextOverflow
                    .ellipsis,
            style:
                const TextStyle(
              fontSize: 13,
              height: 1.5,
              color:
                  AppColors
                      .textGrey,
            ),
          ),

          const SizedBox(
            height: 17,
          ),

          Align(
            alignment:
                Alignment
                    .centerRight,
            child:
                BrandActionButtons(
              onEdit:
                  onEdit,
              onDelete:
                  onDelete,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandIcon() {
    return const Center(
      child: Icon(
        Icons
            .storefront_outlined,
        size: 30,
        color:
            AppColors.primary,
      ),
    );
  }
}