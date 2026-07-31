import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/widgets/products/product_image_box.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_status_badge.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductMobileCard extends StatelessWidget {
  const ProductMobileCard({
    super.key,
    required this.product,
    required this.onMenuSelected,
  });

  final Map<String, dynamic> product;

  final ValueChanged<String> onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final stock = product['stock'] as int;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const ProductImageBox(),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'].toString(),
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w800,
                        color:
                            AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${product['category']} • '
                      '${product['brand']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color:
                            AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              _productMenu(),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _info(
                  'Price',
                  '₹${product['price']}',
                ),
              ),
              Expanded(
                child: _info(
                  'Stock',
                  '$stock',
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 11,
                        color:
                            AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ProductStatusBadge(
                      status: product[
                          'status'],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _productMenu() {
    return PopupMenuButton<String>(
      tooltip: 'Product options',
      icon: const Icon(
        Icons.more_vert_rounded,
      ),
      onSelected: onMenuSelected,
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 'view',
            child: Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                ),
                SizedBox(width: 12),
                Text('View'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit_outlined),
                SizedBox(width: 12),
                Text('Edit'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'status',
            child: Row(
              children: [
                const Icon(
                  Icons.sync_alt_rounded,
                ),
                const SizedBox(width: 12),
                Text(
                  product['status'] ==
                          'Active'
                      ? 'Make Inactive'
                      : 'Make Active',
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                SizedBox(width: 12),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}