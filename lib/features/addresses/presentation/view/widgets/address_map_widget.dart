import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/features/addresses/data/mappers/latlng_coordinates_mapper.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class AddressMapWidget extends StatefulWidget {
  final CoordinatesEntity? selectedLocation;
  final ValueChanged<CoordinatesEntity>? onLocationSelected;
  final String mapTilerApiKey;

  const AddressMapWidget({
    super.key,
    this.selectedLocation,
    this.onLocationSelected,
    required this.mapTilerApiKey,
  });

  @override
  State<AddressMapWidget> createState() => _AddressMapWidgetState();
}

class _AddressMapWidgetState extends State<AddressMapWidget> {
  late final MapController _mapController;


  static const CoordinatesEntity _defaultLocation = CoordinatesEntity(
    latitude: 30.0444,
    longitude: 31.2357,
  ); // Cairo

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void didUpdateWidget(covariant AddressMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedLocation != null &&
        widget.selectedLocation != oldWidget.selectedLocation) {
      _mapController.move(widget.selectedLocation!.toLatLng(), 16.0);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeLocation = widget.selectedLocation ?? _defaultLocation;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: activeLocation.toLatLng(),
            initialZoom: 15.0,
            minZoom: 3.0,
            maxZoom: 18.0,
            interactionOptions: const InteractionOptions(
              flags:
                  InteractiveFlag.drag |
                  InteractiveFlag.pinchZoom |
                  InteractiveFlag.doubleTapZoom,
            ),
            onTap: (tapPosition, point) {
              widget.onLocationSelected?.call(point.toEntity());
            },
          ),
          children: [
            TileLayer(
              urlTemplate: AppConstants.mapTilerUrlTemplate,
              additionalOptions: {
                AppConstants.mapTilerApiKeyQueryParam: widget.mapTilerApiKey,
              },
              userAgentPackageName: AppConstants.appPackageName,
              fallbackUrl: AppConstants.mapFallbackUrl,
            ),
            if (widget.selectedLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: widget.selectedLocation!.toLatLng(),
                    width: 44,
                    height: 44,
                    alignment: Alignment.topCenter,
                    child: _buildMapPin(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPin() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.purpleBase,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purpleBase.withValues(alpha: 0.35),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
        CustomPaint(
          size: const Size(10, 6),
          painter: _TrianglePainter(color: AppColors.purpleBase),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
