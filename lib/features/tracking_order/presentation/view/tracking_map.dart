import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_cubit.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class TrackingMap extends StatefulWidget {
  const TrackingMap({
    super.key,
    required this.tracking,
    required this.estimatedDeliveryAt,
    required this.routePoints,
  });

  final OrderTrackingEntity tracking;
  final DateTime? estimatedDeliveryAt;
  final List<LatLng> routePoints;

  @override
  State<TrackingMap> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  Widget _labelPin({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryPink,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.location_on, size: 28, color: AppColors.primaryPink),
      ],
    );
  }

  Widget _buildMap({
    required OrderTrackingEntity tracking,
    required List<LatLng> routePoints,
    required LatLng? userLocation,
  }) {
    final l10n = AppLocalizations.of(context)!;

    final storeLocation = tracking.storeLocation == null
        ? null
        : LatLng(tracking.storeLocation!.lat, tracking.storeLocation!.lng);

    final driverLocation = tracking.lastKnownLocation == null
        ? null
        : LatLng(
            tracking.lastKnownLocation!.lat,
            tracking.lastKnownLocation!.lng,
          );

    final destination = LatLng(
      tracking.destination.lat,
      tracking.destination.lng,
    );

    final coordinates = <LatLng>[destination];

    if (storeLocation != null) {
      coordinates.add(storeLocation);
    }

    if (driverLocation != null) {
      coordinates.add(driverLocation);
    }

    if (userLocation != null) {
      coordinates.add(userLocation);
    }

    if (routePoints.isNotEmpty) {
      coordinates.addAll(routePoints);
    }

    debugPrint(
      '🗺️ MAP DRIVER: '
      '${tracking.lastKnownLocation?.lat}, '
      '${tracking.lastKnownLocation?.lng}',
    );

    debugPrint(
      '🗺️ MAP CLIENT: '
      '${tracking.destination.lat}, '
      '${tracking.destination.lng}',
    );

    debugPrint(
      '🗺️ MAP STORE: '
      '${tracking.storeLocation?.lat}, '
      '${tracking.storeLocation?.lng}',
    );

    debugPrint(
      '🗺️ MAP USER: '
      '${userLocation?.latitude}, '
      '${userLocation?.longitude}',
    );

    debugPrint('🗺️ MAP ROUTE POINTS: ${routePoints.length}');

    return FlutterMap(
      options: MapOptions(
        initialCenter: driverLocation ?? storeLocation ?? destination,
        initialZoom: 14,
        initialCameraFit: CameraFit.coordinates(
          coordinates: coordinates,
          padding: const EdgeInsets.all(70),
        ),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.elevate.t5.flowrist',
        ),

        // OSRM road route.
        if (routePoints.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 4,
                color: AppColors.primaryPink,
              ),
            ],
          ),

        MarkerLayer(
          markers: [
            // Destination
            Marker(
              point: destination,
              width: 100,
              height: 60,
              alignment: Alignment.topCenter,
              child: _labelPin(icon: Icons.home_rounded, label: l10n.apartment),
            ),

            // Store
            if (storeLocation != null)
              Marker(
                point: storeLocation,
                width: 100,
                height: 60,
                alignment: Alignment.topCenter,
                child: _labelPin(icon: Icons.local_florist, label: l10n.flower),
              ),

            // Driver
            if (driverLocation != null)
              Marker(
                point: driverLocation,
                width: 50,
                height: 50,
                child: Image.asset(AppImages.flowerTrackingOrderMotorcycle),
              ),

            // Current user location
            if (userLocation != null)
              Marker(
                point: userLocation,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.my_location,
                  size: 24,
                  color: Colors.blue,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderInfo({
    required OrderTrackingEntity tracking,
    required DateTime? estimatedDeliveryAt,
  }) {
    final l10n = AppLocalizations.of(context)!;

    final driverName = tracking.driver?.name ?? l10n.driver;

    final deliveryTime = estimatedDeliveryAt == null
        ? '--'
        : DateFormat(
            Endpoints.dateFormatDelivery,
          ).format(estimatedDeliveryAt.toLocal());

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.estimatedArrival, style: AppStyles.regular14Inter),
          Text(deliveryTime, style: AppStyles.medium16InterBlack),

          const SizedBox(height: 30),

          Row(
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
                  Text(
                    l10n.deliveryHeroDescription,
                    style: AppStyles.regular13,
                  ),
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
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: l10n.orderDetails,
              onPressed: () {
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingCubit, TrackingState>(
      builder: (context, state) {
        final tracking = state.tracking ?? widget.tracking;

        final routePoints = state.routePoints.isNotEmpty
            ? state.routePoints
            : widget.routePoints;

        final estimatedDeliveryAt =
            state.estimatedDeliveryAt ?? widget.estimatedDeliveryAt;

        final userLocation = state.userLocation;

        debugPrint('🔄 MAP REBUILT');

        debugPrint(
          '📍 CURRENT DRIVER: '
          '${tracking.lastKnownLocation?.lat}, '
          '${tracking.lastKnownLocation?.lng}',
        );

        debugPrint(
          '📍 CURRENT USER: '
          '${userLocation?.latitude}, '
          '${userLocation?.longitude}',
        );

        debugPrint(
          '🛣️ CURRENT ROUTE: '
          '${routePoints.length}',
        );

        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: _buildMap(
                  tracking: tracking,
                  routePoints: routePoints,
                  userLocation: userLocation,
                ),
              ),

              _buildOrderInfo(
                tracking: tracking,
                estimatedDeliveryAt: estimatedDeliveryAt,
              ),
            ],
          ),
        );
      },
    );
  }
}
