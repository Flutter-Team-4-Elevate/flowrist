import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/shared/product_details/data/models/product_details_request_dto.dart';
import 'package:flutter/material.dart';

class ProductPriceAndStatus extends StatelessWidget {
  final ProductDetailsRequestDto product;

  const ProductPriceAndStatus({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentPrice = product.discountedPrice ?? product.price;
    final hasDiscount =
        product.discountedPrice != null &&
        product.discountedPrice! < product.price;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${currentPrice.toStringAsFixed(0)} ${l10n.egp}',
                  style: AppStyles.bold20Inter,
                ),
                if (hasDiscount) ...[
                  const SizedBox(width: 8),
                  Text(
                    '${product.price.toStringAsFixed(0)} ${l10n.egp}',
                    style: AppStyles.regular14Inter.copyWith(
                      color: AppColors.white70,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(l10n.allPricesIncludeTax, style: AppStyles.regular12Inter),
          ],
        ),
        Row(
          children: [
            Text('${l10n.status}: ', style: AppStyles.semiBold14),
            Text(
              product.inStock ? l10n.productInStock : l10n.productOutOfStock,
              style: AppStyles.regular14InterW500.copyWith(
                color: product.inStock ? AppColors.grey : AppColors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
