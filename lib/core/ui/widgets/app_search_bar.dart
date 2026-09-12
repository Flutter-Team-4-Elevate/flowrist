import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const AppSearchBar({
    super.key,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      canRequestFocus: !readOnly,
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.search,
        hintStyle: AppStyles.regular14InterW500.copyWith(
          color: AppColors.white70,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.white70,
          size: 18,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: readOnly ? AppColors.white70 : AppColors.purpleBase,
          ),
        ),
      ),
    );
  }
}
