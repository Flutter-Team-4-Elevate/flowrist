import 'package:flutter/material.dart';

import '../../../../../../config/l10n/app_localizations.dart';
import '../../data/models/product_details_request_dto.dart';

class StockInformation extends StatelessWidget {
  final ProductDetailsRequestDto product;
  final AppLocalizations localizations;

  const StockInformation({
    super.key,
    required this.product,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_outlined),
          const SizedBox(width: 12),
          Text(
            '${localizations.productAvailableStock}: '
            '${product.availableStock}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
