import 'package:latlong2/latlong.dart';

class CoordinatesEntity {
  final double latitude;
  final double longitude;

  const CoordinatesEntity({required this.latitude, required this.longitude});

  LatLng toLatLng() => LatLng(latitude, longitude);
}
