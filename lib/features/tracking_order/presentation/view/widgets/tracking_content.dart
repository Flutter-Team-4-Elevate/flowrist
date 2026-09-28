import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_cubit.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_event.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_state.dart';
import 'package:flowrist/features/tracking_order/presentation/widgets/order_status_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TrackingContent extends StatelessWidget {
  final OrderTrackingEntity tracking;
  final DateTime? estimatedDeliveryAt;

  const TrackingContent({
    super.key,
    required this.tracking,
    required this.estimatedDeliveryAt,
  });

  @override
  Widget build(BuildContext context) {
    final isMapDisabled = [
      'PREPARING',
      'ARRIVED',
      'AWAITING_DELIVERY_CONFIRMATION',
      'DELIVERED',
    ].contains(tracking.status);

    final driver = tracking.driver;

    final deliveryTime = estimatedDeliveryAt == null
        ? '--'
        : DateFormat(
            Endpoints.dateFormatDelivery,
          ).format(estimatedDeliveryAt!.toLocal());

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estimated arrival', style: AppStyles.regular14Inter),

            Text(deliveryTime, style: AppStyles.medium16InterBlack),

            const SizedBox(height: 40),

            _DriverSection(driverName: driver?.name ?? ''),

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

            _TrackingActions(
              isMapDisabled: isMapDisabled,
              status: tracking.status,
              orderId: tracking.orderId,
              tracking: tracking,
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverSection extends StatelessWidget {
  final String driverName;

  const _DriverSection({required this.driverName});

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
  final bool isMapDisabled;
  final String orderId;
  final String status;
  final OrderTrackingEntity tracking;

  const _TrackingActions({
    required this.status,
    required this.orderId,
    required this.tracking,
    required this.isMapDisabled,
  });

  @override
  Widget build(BuildContext context) {
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
                      context.push(AppRoutes.trackingMap, extra: tracking);
                    },
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: BlocBuilder<TrackingCubit, TrackingState>(
              buildWhen: (previous, current) =>
                  previous.isConfirmingDelivery !=
                      current.isConfirmingDelivery ||
                  previous.isDeliveryConfirmed != current.isDeliveryConfirmed,
              builder: (context, state) {
                return AppButton(
                  text: state.isConfirmingDelivery
                      ? 'Confirming...'
                      : state.isDeliveryConfirmed
                      ? 'Delivered'
                      : 'Order Delivered',
                  onPressed:
                      state.isConfirmingDelivery || state.isDeliveryConfirmed
                      ? null
                      : () {
                          context.read<TrackingCubit>().doEvent(
                            ConfirmDelivery(orderId: orderId),
                          );
                        },
                );
              },
            ),
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
                context.push(AppRoutes.trackingMap, extra: tracking);
              },
      ),
    );
  }
}
