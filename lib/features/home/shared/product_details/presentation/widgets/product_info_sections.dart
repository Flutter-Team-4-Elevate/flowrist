import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class ProductDescriptionSection extends StatelessWidget {
  final String description;

  const ProductDescriptionSection({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.productDescription, style: AppStyles.semiBold14),
        const SizedBox(height: 8),
        Text(
          description.isNotEmpty ? description : l10n.noProductsFound,
          style: AppStyles.regular14InterGreyHeight15,
        ),
      ],
    );
  }
}

class ProductIncludesSection extends StatelessWidget {
  final List<String> includes;

  const ProductIncludesSection({super.key, required this.includes});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.productIncludes, style: AppStyles.semiBold14),
        const SizedBox(height: 8),
        ...includes.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.purpleBase,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: AppStyles.regular14InterGreyHeight15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
