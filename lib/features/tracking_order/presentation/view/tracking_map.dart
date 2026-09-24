import 'dart:async';

import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

final List<LatLng> dummyDriverLocations = [
  const LatLng(30.0500, 31.2300),
  const LatLng(30.0480, 31.2320),
  const LatLng(30.0460, 31.2340),
  const LatLng(30.0450, 31.2350),
];

class TrackingMap extends StatefulWidget {
  const TrackingMap({super.key});

  @override
  State<TrackingMap> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  LatLng? _userLocation;

  final LatLng _storeLocation = const LatLng(30.0444, 31.2357);

  LatLng _driverLocation = dummyDriverLocations.first;

  int _driverLocationIndex = 0;

  Timer? _driverTimer;

  @override
  void initState() {
    super.initState();

    _getUserLocation();
    _startDummyDriverTracking();
  }

  void _startDummyDriverTracking() {
    _driverTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted) return;

      setState(() {
        _driverLocationIndex++;

        // Start again from the first location
        if (_driverLocationIndex >= dummyDriverLocations.length) {
          _driverLocationIndex = 0;
        }

        _driverLocation = dummyDriverLocations[_driverLocationIndex];
      });
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

  @override
  void dispose() {
    _driverTimer?.cancel();
    super.dispose();
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

    final apartment = _userLocation ?? const LatLng(30.0520, 31.2250);

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
    const String driverName = "Mohammad";
    const String time = "11:00 AM";
    const String arrivalDate = "03 Sep 2024";

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Estimated arrival', style: AppStyles.regular14Inter),
          Text("$arrivalDate, $time", style: AppStyles.medium16InterBlack),

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
            child: AppButton(text: "Order details", onPressed: () {}),
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
