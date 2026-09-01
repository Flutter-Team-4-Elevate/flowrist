import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flutter/material.dart';

class SavedAddressItemCard extends StatelessWidget {
  final AddressEntity address;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SavedAddressItemCard({
    super.key,
    required this.address,
    this.onEdit,
    this.onDelete,
  });

  String _formatSubtitle() {
    final parts = <String>[];
    if (address.addressLine.isNotEmpty) {
      parts.add(address.addressLine);
    }
    if (address.area.isNotEmpty) {
      parts.add(address.area);
    }
    return parts.join(' - ');
  }

  @override
  Widget build(BuildContext context) {
    final title = address.city.isNotEmpty
        ? address.city
        : (address.label?.isNotEmpty == true ? address.label! : address.area);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white60.withAlpha(80), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.location_on_outlined,
              size: 24,
              color: AppColors.blackBase,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.medium16InterBlack,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  _formatSubtitle(),
                  style: AppStyles.regular13Grey,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete, color: AppColors.red60, size: 20),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.grey,
                  size: 20,
                ),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
