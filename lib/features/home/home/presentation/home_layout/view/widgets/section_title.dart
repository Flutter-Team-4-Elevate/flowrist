import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const SectionTitle({super.key, required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppStyles.medium18Inter),
          TextButton(
            onPressed: onViewAll,
            child: Text(
              localizations.viewAll,
              style: AppStyles.medium18Inter.copyWith(
                fontSize: 12,
                color: AppColors.purpleBase,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.purpleBase,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
