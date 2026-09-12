import 'package:flutter/material.dart';

import '../../data/models/product_details_request_dto.dart';

class PriceSection extends StatelessWidget {
  final ProductDetailsRequestDto product;

  const PriceSection({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDiscount = product.discountedPrice != null &&
        product.discountPercent != null &&
        product.discountPercent! > 0;

    // السعر المعروض (سعر الخصم إذا وجد، وإلا السعر الأصلي)
    final displayPrice = hasDiscount ? product.discountedPrice! : product.price;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // السعر الحالي
        Text(
          '${displayPrice.toStringAsFixed(0)} EGP',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        // يظهر فقط لو في خصم
        if (hasDiscount) ...[
          const SizedBox(width: 12),

          // السعر الأصلي مشطوب عليه
          Text(
            '${product.price.toStringAsFixed(0)} EGP',
            style: theme.textTheme.bodyLarge?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),

          const SizedBox(width: 12),

          // نسبة الخصم
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: theme.colorScheme.primary,
            ),
            child: Text(
              '${product.discountPercent!.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}