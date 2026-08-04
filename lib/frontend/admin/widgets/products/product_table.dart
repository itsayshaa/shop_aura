import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/admin/widgets/products/product_image_box.dart';
import 'package:shop_aura/frontend/admin/widgets/products/product_status_badge.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class ProductTable extends StatelessWidget {
  const ProductTable({
    super.key,
    required this.products,
    required this.onMenuSelected,
  });

  final List<Map<String, dynamic>> products;

  final void Function(
    String action,
    Map<String, dynamic> product,
  ) onMenuSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              18,
              18,
              18,
              14,
            ),
            child: Row(
              children: [
                const Text(
                  'All Products',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        AppColors.textDark,
                  ),
                ),
                const Spacer(),
                Text(
                  '${products.length} products',
                  style: const TextStyle(
                    color:
                        AppColors.textGrey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SingleChildScrollView(
            scrollDirection:
                Axis.horizontal,
            child: SizedBox(
              width: 1080,
              child: Column(
                children: [
                  _header(),
                  if (products.isEmpty)
                    const SizedBox(
                      height: 220,
                      child: Center(
                        child: Text(
                          'No products found',
                        ),
                      ),
                    )
                  else
                    ...products.map(
                      _tableRow,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      height: 58,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      color: const Color(0xFFF8F8FA),
      child: const Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              'IMAGE',
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'PRODUCT',
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'CATEGORY',
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'BRAND',
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: Text(
              'PRICE',
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              'STOCK',
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              'STATUS',
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              'ACTION',
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableRow(
    Map<String, dynamic> product,
  ) {
    final stock = product['stock'] as int;

    final isLowStock =
        stock > 0 && stock <= 10;

    return Container(
      height: 92,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 75,
            child: ProductImageBox(),
          ),
          Expanded(
            flex: 3,
            child: Text(
              product['name'].toString(),
              maxLines: 2,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight:
                    FontWeight.w700,
                color:
                    AppColors.textDark,
              ),
            ),
          ),
          Expanded(
            child: Text(
              product['category']
                  .toString(),
            ),
          ),
          Expanded(
            child: Text(
              product['brand'].toString(),
            ),
          ),
          SizedBox(
            width: 110,
            child: Text(
              '₹${product['price']}',
              style: const TextStyle(
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              isLowStock
                  ? '$stock Low'
                  : '$stock',
              style: TextStyle(
                color: isLowStock
                    ? Colors.orange
                    : AppColors.textDark,
                fontWeight:
                    isLowStock
                        ? FontWeight.w700
                        : FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: ProductStatusBadge(
              status:
                  product['status'],
            ),
          ),
          SizedBox(
            width: 70,
            child: _menu(product),
          ),
        ],
      ),
    );
  }

  Widget _menu(
    Map<String, dynamic> product,
  ) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert_rounded,
      ),
      onSelected: (action) {
        onMenuSelected(
          action,
          product,
        );
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 'view',
            child: Text('View'),
          ),
          const PopupMenuItem(
            value: 'edit',
            child: Text('Edit'),
          ),
          PopupMenuItem(
            value: 'status',
            child: Text(
              product['status'] ==
                      'Active'
                  ? 'Make Inactive'
                  : 'Make Active',
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: 'delete',
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ];
      },
    );
  }
}