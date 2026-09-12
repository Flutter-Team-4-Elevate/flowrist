import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/ui/widgets/product_card.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchProductsGrid extends StatelessWidget {
  final List<ProductEntity> products;

  const SearchProductsGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    final crossSpacing = screenWidth * 0.04;
    final mainSpacing = screenHeight * 0.022;

    return GridView.builder(
      itemCount: products.length,
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: mainSpacing,
        crossAxisSpacing: crossSpacing,
        childAspectRatio: 0.60,
      ),
      itemBuilder: (context, index) =>
          _buildProductItem(context, products[index]),
    );
  }

  Widget _buildProductItem(BuildContext context, ProductEntity product) {
    final discount = product.discountPercentage != null
        ? '${product.discountPercentage!.toInt()}%'
        : '';

    return GestureDetector(
      onTap: () => context.push(AppRoutes.productDetailsPath(product.id)),
      child: ProductCard(
        productId: product.id,
        title: product.name,
        price: product.price.toString(),
        oldPrice: product.discountPrice?.toString() ?? '',
        discount: discount,
        image: product.imageUrl,
      ),
    );
  }
}
