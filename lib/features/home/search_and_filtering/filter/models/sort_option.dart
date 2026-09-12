import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

enum SortOption {
  lowestPrice(AppConstants.sortPriceLowToHigh),
  highestPrice(AppConstants.sortPriceHighToLow),
  newest(AppConstants.sortNewestFirst),
  oldest(AppConstants.sortOldestFirst);

  final String apiValue;
  const SortOption(this.apiValue);

  String getTitle(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (this) {
      case SortOption.lowestPrice:
        return localizations.lowestPrice;
      case SortOption.highestPrice:
        return localizations.highestPrice;
      case SortOption.newest:
        return localizations.newest;
      case SortOption.oldest:
        return localizations.oldest;
    }
  }
}