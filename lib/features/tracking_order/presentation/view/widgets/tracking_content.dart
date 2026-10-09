import 'package:flowrist/config/l10n/app_localizations.dart';
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
import 'package:flowrist/features/tracking_order/presentation/widgets/order_status_extension.dart';
import 'package:flowrist/features/tracking_order/presentation/widgets/order_status_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final driver = tracking.driver;

    final deliveryTime = estimatedDeliveryAt == null
        ? l10n.unknownDeliveryTime
        : DateFormat(
            Endpoints.dateFormatDelivery,
            Localizations.localeOf(context).toString(),
          ).format(estimatedDeliveryAt!.toLocal());

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.estimatedArrival,
              style: AppStyles.regular14Inter.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .7),
              ),
            ),

            Text(
              deliveryTime,
              style: AppStyles.medium16InterBlack.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

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
              status: tracking.status,
              orderId: tracking.orderId,
              tracking: tracking,
              estimatedDeliveryAt: estimatedDeliveryAt,
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
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        const SizedBox(width: 20),

        SizedBox(
          height: 36,
          width: 36,
          child: Image.asset(AppImages.flowerTrackingOrderBoy),
        ),

        const SizedBox(width: 20),

        // Expanded fixes the horizontal overflow.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driverName,
                style: AppStyles.regular14InterW500.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                l10n.deliveryHeroDescription,
                style: AppStyles.regular13.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

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
  final String orderId;
  final String status;
  final OrderTrackingEntity tracking;
  final DateTime? estimatedDeliveryAt;

  const _TrackingActions({
    required this.status,
    required this.orderId,
    required this.tracking,
    this.estimatedDeliveryAt,
  });

  void _openTrackingMap(BuildContext context) {
    // Get the latest route generated by TrackingCubit.
    final routePoints = context.read<TrackingCubit>().state.routePoints;

    context.push(
      AppRoutes.trackingMap,
      extra: TrackingMapArgs(
        tracking: tracking,
        estimatedDeliveryAt: estimatedDeliveryAt,
        routePoints: routePoints,
        trackingCubit: context.read<TrackingCubit>(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMapEnabled = status.isMapEnabled;

    final isAwaitingDeliveryConfirmation =
        status.isAwaitingDeliveryConfirmation;

    // Condition fixed: the button is enabled WHEN the map is enabled.
    final VoidCallback? onShowMap = isMapEnabled
        ? () => _openTrackingMap(context)
        : null;

    if (isAwaitingDeliveryConfirmation) {
      return Row(
        children: [
          Expanded(
            child: AppButton(text: l10n.showMap, onPressed: onShowMap),
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
                      ? l10n.confirming
                      : state.isDeliveryConfirmed
                      ? l10n.delivered
                      : l10n.orderDelivered,
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
      child: AppButton(text: l10n.showMap, onPressed: onShowMap),
    );
  }
}

class TrackingMapArgs {
  final OrderTrackingEntity tracking;
  final DateTime? estimatedDeliveryAt;
  final List<LatLng> routePoints;
  final TrackingCubit trackingCubit;

  const TrackingMapArgs({
    required this.tracking,
    required this.estimatedDeliveryAt,
    required this.routePoints,
    required this.trackingCubit,
  });
}
