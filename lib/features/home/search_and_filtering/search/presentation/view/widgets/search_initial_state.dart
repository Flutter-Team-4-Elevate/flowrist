import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class SearchInitialState extends StatelessWidget {
  const SearchInitialState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Text(
          l10n.searchForAnyProductYouWant,
          textAlign: TextAlign.center,
          style: AppStyles.regular16.copyWith(
            color: AppColors.purpleBase,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
