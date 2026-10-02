import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/tracking_destination_entity.dart';

part 'tracking_destination_model.g.dart';

@JsonSerializable()
class TrackingDestinationModel {
  final double lat;
  final double lng;
  final String recipientName;
  final String addressLine;
  final String city;
  final String area;

  const TrackingDestinationModel({
    required this.lat,
    required this.lng,
    required this.recipientName,
    required this.addressLine,
    required this.city,
    required this.area,
  });

  factory TrackingDestinationModel.fromJson(Map<String, dynamic> json) =>
      _$TrackingDestinationModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingDestinationModelToJson(this);

  TrackingDestinationEntity toEntity() {
    return TrackingDestinationEntity(
      lat: lat,
      lng: lng,
      recipientName: recipientName,
      addressLine: addressLine,
      city: city,
      area: area,
    );
  }
}
