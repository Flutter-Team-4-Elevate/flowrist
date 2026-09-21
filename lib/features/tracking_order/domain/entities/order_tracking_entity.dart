import 'package:equatable/equatable.dart';
import 'tracking_destination_entity.dart';
import 'tracking_driver_entity.dart';
import 'tracking_location_entity.dart';
import 'tracking_timeline_entity.dart';

class OrderTrackingEntity extends Equatable {
  final String orderId;
  final String orderNumber;
  final String status;
  final bool isTrackingActive;
  final List<TrackingTimelineEntity> timeline;
  final TrackingDriverEntity? driver;
  final TrackingLocationEntity? lastKnownLocation;
  final TrackingDestinationEntity destination;

  const OrderTrackingEntity({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.isTrackingActive,
    required this.timeline,
    this.driver,
    this.lastKnownLocation,
    required this.destination,
  });

  OrderTrackingEntity copyWith({
    String? status,
    bool? isTrackingActive,
    List<TrackingTimelineEntity>? timeline,
    TrackingDriverEntity? driver,
    TrackingLocationEntity? lastKnownLocation,
    TrackingDestinationEntity? destination,
  }) {
    return OrderTrackingEntity(
      orderId: orderId,
      orderNumber: orderNumber,
      status: status ?? this.status,
      isTrackingActive: isTrackingActive ?? this.isTrackingActive,
      timeline: timeline ?? this.timeline,
      driver: driver ?? this.driver,
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      destination: destination ?? this.destination,
    );
  }

  @override
  List<Object?> get props => [
    orderId,
    orderNumber,
    status,
    isTrackingActive,
    timeline,
    driver,
    lastKnownLocation,
    destination,
  ];
}
