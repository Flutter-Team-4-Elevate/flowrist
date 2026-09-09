import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onActionPressed;
  final VoidCallback? onTap;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.onActionPressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isCompleted = order.displayStatus == OrderDisplayStatus.completed;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.white60),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildThumbnail(mediaQuery.size.width),
            const SizedBox(width: 12),
            Expanded(child: _buildDetails(context, isCompleted)),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(double screenWidth) {
    final imageSize = screenWidth * 0.22;
    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child:
          order.firstItemThumbnailUrl != null &&
              order.firstItemThumbnailUrl!.isNotEmpty
          ? Image.network(
              order.firstItemThumbnailUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildFallbackIcon(),
            )
          : _buildFallbackIcon(),
    );
  }

  Widget _buildFallbackIcon() {
    return const Center(
      child: Icon(Icons.local_florist, color: AppColors.purpleBase, size: 32),
    );
  }

  Widget _buildDetails(BuildContext context, bool isCompleted) {
    final locale = AppLocalizations.of(context)!;
    final formattedDate = order.createdAt != null
        ? DateFormat('d MMM yyyy').format(order.createdAt!)
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          order.rawStatus,
          style: AppStyles.regular13Grey,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${locale.egp} ${order.total.toStringAsFixed(0)}',
          style: AppStyles.medium16InterBlack,
        ),
        const SizedBox(height: 4),
        Text(
          isCompleted
              ? '${locale.deliveredOn} $formattedDate'
              : '${locale.orderNumberPrefix} ${order.orderNumber}',
          style: AppStyles.regular12Roboto,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        _buildActionButton(context, isCompleted),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, bool isCompleted) {
    final locale = AppLocalizations.of(context)!;
    final label = isCompleted ? locale.reorder : locale.trackOrder;

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purpleBase,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        onPressed: onActionPressed,
        child: Text(
          label,
          style: AppStyles.medium16Inter.copyWith(fontSize: 14),
        ),
      ),
    );
  }
}
