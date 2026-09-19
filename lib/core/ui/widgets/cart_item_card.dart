import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:flowrist/core/constants/app_images.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onDelete;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final bool isLoading;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onIncrease,
    required this.onDecrease,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey, width: 0.5),
      ),
      child: Row(
        children: [
          _buildProductImage(),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.productName,
                        style: AppStyles.medium16InterBlack,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    IconButton(
                      onPressed: isLoading ? null : onDelete,
                      icon: Icon(Icons.delete_outline, color: AppColors.red),
                    ),
                  ],
                ),

                Text(
                  '${localization.availableStock}: ${item.availableStock}',
                  style: AppStyles.regular13Grey,
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Text(
                      '${localization.egp} ${item.unitPrice}',
                      style: AppStyles.semiBold14,
                    ),

                    const Spacer(),

                    IconButton(
                      onPressed: isLoading ? null : onDecrease,
                      icon: const Icon(
                        Icons.remove,
                        color: AppColors.blackBase,
                      ),
                    ),

                    Text(
                      item.quantity.toString(),
                      style: AppStyles.regular14Inter,
                    ),

                    IconButton(
                      onPressed: isLoading ? null : onIncrease,
                      icon: const Icon(Icons.add, color: AppColors.blackBase),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    if (item.productImage.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          AppImages.cardDefultImage,
          width: 100,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: item.productImage,
        width: 100,
        height: 120,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return Image.asset(
            AppImages.cardDefultImage,
            width: 100,
            height: 120,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
