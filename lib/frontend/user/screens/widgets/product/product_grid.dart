import 'package:flutter/material.dart';

import 'product_card.dart';
import '../../../../models/product_model.dart';

class ProductGrid extends StatefulWidget {
  final List<ProductModel> products;
  final Function(ProductModel)? onProductTap;
  final Function(ProductModel)? onFavourite;

  const ProductGrid({
    super.key,
    required this.products,
    this.onProductTap,
    this.onFavourite,
  });

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 80,
                color: Colors.grey,
              ),
              SizedBox(height: 15),
              Text(
                "No Products Found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.products.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: .63,
      ),
      itemBuilder: (context, index) {
        final product = widget.products[index];

        return TweenAnimationBuilder<double>(
          duration: Duration(
            milliseconds: 250 + (index * 80),
          ),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(
                0,
                40 * (1 - value),
              ),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: ProductCard(
            product: product,
            onTap: () =>
                widget.onProductTap?.call(product),
            onFavourite: () =>
                widget.onFavourite?.call(product),
          ),
        );
      },
    );
  }
}