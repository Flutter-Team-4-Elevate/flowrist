import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/tracking_driver_entity.dart';

part 'tracking_driver_model.g.dart';

@JsonSerializable()
class TrackingDriverModel {
  final String? id;
  final String? name;
  final String? phone;
  final String? image;

  const TrackingDriverModel({this.id, this.name, this.phone, this.image});

  factory TrackingDriverModel.fromJson(Map<String, dynamic> json) =>
      _$TrackingDriverModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingDriverModelToJson(this);

  TrackingDriverEntity toEntity() {
    return TrackingDriverEntity(id: id, name: name, phone: phone, image: image);
  }
}
