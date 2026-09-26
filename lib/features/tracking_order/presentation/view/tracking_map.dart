import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class TrackingMap extends StatefulWidget {
  const TrackingMap({super.key, required this.tracking});

  final OrderTrackingEntity tracking;

  @override
  State<TrackingMap> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  LatLng? _userLocation;
  DateTime? _estimatedDeliveryAt;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  // Store location comes from API
  LatLng get _storeLocation => LatLng(
    widget.tracking.storeLocation!.lat,
    widget.tracking.storeLocation!.lng,
  );

  // Destination comes from API
  LatLng get _destination =>
      LatLng(widget.tracking.destination.lat, widget.tracking.destination.lng);

  // Keep bike in UI for now.
  // Replace this with the driver's real location
  // when the backend provides it.
  final LatLng _driverLocation = const LatLng(30.0500, 31.2300);

  @override
  void initState() {
    super.initState();
    _loadEstimatedDeliveryAt();
    _getUserLocation();
  }

  Future<void> _loadEstimatedDeliveryAt() async {
    final value = await _secureStorage.read(
      key: AppConstants.estimatedDeliveryAtKey,
    );

    if (value == null || value.isEmpty) return;

    final estimatedDeliveryAt = DateTime.tryParse(value);

    if (!mounted) return;

    setState(() {
      _estimatedDeliveryAt = estimatedDeliveryAt;
    });
  }

  Future<void> _getUserLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) return;

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();

    if (!mounted) return;

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

    final apartment = _userLocation ?? _destination;

    return FlutterMap(
      options: MapOptions(
        initialCenter: _storeLocation,
        initialZoom: 14,
        initialCameraFit: CameraFit.coordinates(
          coordinates: [apartment, _driverLocation, _storeLocation],
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
            Polyline(
              points: [apartment, _driverLocation, _storeLocation],
              strokeWidth: 3,
              color: pink,
            ),
          ],
        ),

        MarkerLayer(
          markers: [
            Marker(
              point: apartment,
              width: 100,
              height: 60,
              alignment: Alignment.topCenter,
              child: _labelPin(icon: Icons.home_rounded, label: 'Apartment'),
            ),

            Marker(
              point: _storeLocation,
              width: 100,
              height: 60,
              alignment: Alignment.topCenter,
              child: _labelPin(icon: Icons.local_florist, label: 'Flower'),
            ),

            Marker(
              point: _driverLocation,
              width: 50,
              height: 50,
              child: Image.asset(AppImages.flowerTrackingOrderMotorcycle),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderInfo() {
    final driverName = widget.tracking.driver?.name ?? 'Driver';
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
          Text('Estimated arrival', style: AppStyles.regular14Inter),

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
                    'Is your delivery hero for today',
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
              text: "Order details",
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
