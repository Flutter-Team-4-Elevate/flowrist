import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_router.dart';

class DeliveryAddressItem extends StatelessWidget {
  final AddressEntity addressEntity;

  const DeliveryAddressItem({super.key, required this.addressEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white90.withValues(alpha: 0.45)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(value: addressEntity.id),
                    Text(
                      addressEntity.label ?? 'Address',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 48.0),
                  child: Text(
                    addressEntity.addressLine,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              context.push(AppRoutes.addAddress, extra: addressEntity);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
