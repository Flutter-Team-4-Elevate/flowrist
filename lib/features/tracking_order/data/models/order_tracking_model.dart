import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/order_tracking_entity.dart';
import 'tracking_destination_model.dart';
import 'tracking_driver_model.dart';
import 'tracking_location_model.dart';
import 'tracking_timeline_model.dart';

part 'order_tracking_model.g.dart';

@JsonSerializable()
class OrderTrackingModel {
  final String orderId;
  final String orderNumber;
  final String status;
  final bool isTrackingActive;

  final List<TrackingTimelineModel> timeline;

  final TrackingDriverModel? driver;

  final TrackingLocationModel? lastKnownLocation;

  final TrackingDestinationModel destination;

  const OrderTrackingModel({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.isTrackingActive,
    required this.timeline,
    this.driver,
    this.lastKnownLocation,
    required this.destination,
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) =>
      _$OrderTrackingModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderTrackingModelToJson(this);

  OrderTrackingEntity toEntity() {
    return OrderTrackingEntity(
      orderId: orderId,
      orderNumber: orderNumber,
      status: status,
      isTrackingActive: isTrackingActive,
      timeline: timeline.map((item) => item.toEntity()).toList(),
      driver: driver?.toEntity(),
      lastKnownLocation: lastKnownLocation?.toEntity(),
      destination: destination.toEntity(),
    );
  }
}
