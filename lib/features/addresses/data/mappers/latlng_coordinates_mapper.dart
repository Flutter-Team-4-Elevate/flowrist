import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:latlong2/latlong.dart';

extension LatlngCoordinatesMapper on LatLng {
  CoordinatesEntity toEntity() {
    return CoordinatesEntity(latitude: latitude, longitude: longitude);
  }
}
