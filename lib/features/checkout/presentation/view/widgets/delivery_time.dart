import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeliveryTime extends StatelessWidget {
  const DeliveryTime({super.key, this.estimatedDeliveryAt});

  final DateTime? estimatedDeliveryAt;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
     
    final deliveryTime = estimatedDeliveryAt == null
    ? '--'
    : DateFormat(
        Endpoints.dateFormatDelivery,
      ).format(
        estimatedDeliveryAt!.toLocal(),
      );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.deliveryTime,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time),
              const SizedBox(width: 8),
              Text(
                localizations.instantArriveBy,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                deliveryTime,
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
