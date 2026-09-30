import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class TrackingMap extends StatefulWidget {
  const TrackingMap({
    super.key,
    required this.tracking,
    required this.secureStorageService,
  });

  final OrderTrackingEntity tracking;
  final SecureStorageService secureStorageService;

  @override
  State<TrackingMap> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  LatLng? _userLocation;
  DateTime? _estimatedDeliveryAt;

  LatLng? get _storeLocation {
    final location = widget.tracking.storeLocation;

    if (location == null) {
      return null;
    }

    return LatLng(location.lat, location.lng);
  }

  LatLng get _destination {
    return LatLng(
      widget.tracking.destination.lat,
      widget.tracking.destination.lng,
    );
  }

  LatLng? get _driverLocation {
    final location = widget.tracking.lastKnownLocation;

    if (location == null) {
      return null;
    }

    return LatLng(location.lat, location.lng);
  }

  @override
  void initState() {
    super.initState();

    _loadEstimatedDeliveryAt();
    _getUserLocation();
  }

  Future<void> _loadEstimatedDeliveryAt() async {
    final value = await widget.secureStorageService.get(
      AppConstants.estimatedDeliveryAtKey,
    );

    if (value.isEmpty) {
      return;
    }

    final estimatedDeliveryAt = DateTime.tryParse(value);

    if (!mounted) {
      return;
    }

    setState(() {
      _estimatedDeliveryAt = estimatedDeliveryAt;
    });
  }

  Future<void> _getUserLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();

    if (!mounted) {
      return;
    }

    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Widget _labelPin({required IconData icon, required String label}) {
    const pink = Color(0xFFD5136B);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: pink,
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
        const Icon(Icons.location_on, size: 28, color: pink),
      ],
    );
  }

  Widget _buildMap() {
    const pink = Color(0xFFD5136B);
    final l10n = AppLocalizations.of(context)!;

    final storeLocation = _storeLocation;
    final driverLocation = _driverLocation;

    // The API destination is the actual apartment/order destination.
    final apartment = _destination;

    final coordinates = <LatLng>[apartment];

    if (storeLocation != null) {
      coordinates.add(storeLocation);
    }

    if (driverLocation != null) {
      coordinates.add(driverLocation);
    }

    final routePoints = <LatLng>[apartment];

    if (driverLocation != null) {
      routePoints.add(driverLocation);
    }

    if (storeLocation != null) {
      routePoints.add(storeLocation);
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: storeLocation ?? apartment,
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

        PolylineLayer(
          polylines: [
            Polyline(points: routePoints, strokeWidth: 3, color: pink),
          ],
        ),

        MarkerLayer(
          markers: [
            Marker(
              point: apartment,
              width: 100,
              height: 60,
              alignment: Alignment.topCenter,
              child: _labelPin(icon: Icons.home_rounded, label: l10n.apartment),
            ),

            if (storeLocation != null)
              Marker(
                point: storeLocation,
                width: 100,
                height: 60,
                alignment: Alignment.topCenter,
                child: _labelPin(icon: Icons.local_florist, label: l10n.flower),
              ),

            if (driverLocation != null)
              Marker(
                point: driverLocation,
                width: 50,
                height: 50,
                child: Image.asset(AppImages.flowerTrackingOrderMotorcycle),
              ),

            if (_userLocation != null)
              Marker(
                point: _userLocation!,
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

  Widget _buildOrderInfo() {
    final l10n = AppLocalizations.of(context)!;

    final driverName = widget.tracking.driver?.name ?? l10n.driver;

    final deliveryTime = _estimatedDeliveryAt == null
        ? '--'
        : DateFormat(
            Endpoints.dateFormatDelivery,
          ).format(_estimatedDeliveryAt!.toLocal());

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
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _buildMap()),
          _buildOrderInfo(),
        ],
      ),
    );
  }
}
