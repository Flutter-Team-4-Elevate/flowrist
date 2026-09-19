import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Text(
          l10n.noProductsFound,
          textAlign: TextAlign.center,
          style: AppStyles.regular14Inter,
        ),
      ),
    );
  }
}
