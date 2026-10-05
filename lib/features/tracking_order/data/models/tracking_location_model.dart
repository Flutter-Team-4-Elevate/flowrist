import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/tracking_location_entity.dart';

part 'tracking_location_model.g.dart';

@JsonSerializable()
class TrackingLocationModel {
  final double lat;
  final double lng;

  const TrackingLocationModel({required this.lat, required this.lng});

  factory TrackingLocationModel.fromJson(Map<String, dynamic> json) =>
      _$TrackingLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingLocationModelToJson(this);

  TrackingLocationEntity toEntity() {
    return TrackingLocationEntity(lat: lat, lng: lng);
  }
}
