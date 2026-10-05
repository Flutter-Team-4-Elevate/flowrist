import 'package:latlong2/latlong.dart';

class RoutingEntity {
  final String code;
  final List<LatLng> points;

  const RoutingEntity({required this.code, required this.points});
}
