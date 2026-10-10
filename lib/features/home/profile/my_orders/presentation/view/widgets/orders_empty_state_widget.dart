import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class OrdersEmptyStateWidget extends StatelessWidget {
  final String? message;

  const OrdersEmptyStateWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppColors.grey20,
          ),
          const SizedBox(height: 16),
          Text(
            message ?? locale.noOrdersFound,
            style: AppStyles.medium16Roboto,
          ),
        ],
      ),
    );
  }
}
