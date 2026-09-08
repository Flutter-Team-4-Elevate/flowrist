import 'package:flutter/material.dart';

import '../../../../../../config/l10n/app_localizations.dart';
import '../../data/models/product_details_request_dto.dart';

class StockStatus extends StatelessWidget {
  final ProductDetailsRequestDto product;
  final AppLocalizations localizations;

  const StockStatus({
    super.key,
    required this.product,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final color = product.inStock ? Colors.green : Colors.red;

    return Row(
      children: [
        Icon(
          product.inStock ? Icons.check_circle : Icons.cancel,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          product.inStock
              ? localizations.productInStock
              : localizations.productOutOfStock,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
