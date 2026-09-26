import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flowrist/features/tracking_order/presentation/widgets/order_status_timeline.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrackingContent extends StatelessWidget {
  final OrderTrackingEntity tracking;

  const TrackingContent({super.key, required this.tracking});

  @override
  Widget build(BuildContext context) {
    final driver = tracking.driver;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estimated arrival', style: AppStyles.regular14Inter),

            Text(
              '03 Sep 2024, 11:00 AM',
              // Later replace with the actual estimated arrival
              // from your API if backend provides it.
              style: AppStyles.medium16InterBlack,
            ),

            const SizedBox(height: 40),

            _DriverSection(driverName: driver?.name ?? 'Mohammad'),

            const SizedBox(height: 50),

            Center(
              child: SizedBox(
                height: 83,
                width: 213,
                child: Image.asset(AppImages.flowerTrackingOrderCar),
              ),
            ),

            const SizedBox(height: 50),

            OrderStatusTimeline(timeline: tracking.timeline),

            const SizedBox(height: 30),

            _TrackingActions(status: tracking.status),
          ],
        ),
      ),
    );
  }
}

class _DriverSection extends StatelessWidget {
  const _DriverSection({required this.driverName});

  final String driverName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),

        SizedBox(
          height: 36,
          width: 36,
          child: Image.asset(AppImages.flowerTrackingOrderBoy),
        ),

        const SizedBox(width: 20),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(driverName, style: AppStyles.regular14InterW500),
            Text('Is your delivery hero for today', style: AppStyles.regular13),
          ],
        ),

        const Spacer(),

        SizedBox(
          height: 18,
          width: 18,
          child: Image.asset(AppImages.flowerTrackingOrderCall),
        ),

        const SizedBox(width: 10),

        SizedBox(
          height: 18,
          width: 18,
          child: Image.asset(AppImages.flowerTrackingOrderWattsapp),
        ),

        const SizedBox(width: 20),
      ],
    );
  }
}

class _TrackingActions extends StatelessWidget {
  const _TrackingActions({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isMapDisabled = [
      'ARRIVED',
      'AWAITING_DELIVERY_CONFIRMATION',
      'DELIVERED',
    ].contains(status);

    final isDelivered = status == 'AWAITING_DELIVERY_CONFIRMATION';

    if (isDelivered) {
      return Row(
        children: [
          Expanded(
            child: AppButton(
              text: 'Show map',
              onPressed: isMapDisabled
                  ? null
                  : () {
                      context.push(AppRoutes.trackingMap);
                    },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppButton(text: 'Order Delivered', onPressed: () {}),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: AppButton(
        text: 'Show map',
        onPressed: isMapDisabled
            ? null
            : () {
                context.push(AppRoutes.trackingMap);
              },
      ),
    );
  }
}
