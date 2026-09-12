import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flutter/material.dart';

class AddressItem extends StatelessWidget {
  final AddressEntity address;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressItem({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.purpleBase : AppColors.white50,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.pink10,
              ),
              child: Icon(
                isSelected
                    ? Icons.location_on_rounded
                    : Icons.location_on_outlined,
                size: 22,
                color: AppColors.purpleBase,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${localizations.deliverTo} ${address.city}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${address.area} • ${address.addressLine}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: AppColors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.purpleBase,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
