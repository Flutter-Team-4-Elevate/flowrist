import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

@immutable
class TrackingState {
  final bool isLoading;
  final bool isConfirmingDelivery;
  final bool isDeliveryConfirmed;
  final String? errorMessage;
  final OrderTrackingEntity? tracking;
  final DateTime? estimatedDeliveryAt;
  final DateTime? lastUpdatedAt;
  final List<LatLng> routePoints;
  final LatLng? userLocation;

  const TrackingState({
    this.isLoading = false,
    this.isConfirmingDelivery = false,
    this.isDeliveryConfirmed = false,
    this.errorMessage,
    this.tracking,
    this.estimatedDeliveryAt,
    this.lastUpdatedAt,
    this.routePoints = const [],
    this.userLocation,
  });

  TrackingState copyWith({
    bool? isLoading,
    bool? isConfirmingDelivery,
    bool? isDeliveryConfirmed,
    String? errorMessage,
    OrderTrackingEntity? tracking,
    DateTime? estimatedDeliveryAt,
    DateTime? lastUpdatedAt,
    List<LatLng>? routePoints,
    LatLng? userLocation,
  }) {
    return TrackingState(
      isLoading: isLoading ?? this.isLoading,
      isConfirmingDelivery: isConfirmingDelivery ?? this.isConfirmingDelivery,
      isDeliveryConfirmed: isDeliveryConfirmed ?? this.isDeliveryConfirmed,
      errorMessage: errorMessage ?? this.errorMessage,
      tracking: tracking ?? this.tracking,
      estimatedDeliveryAt: estimatedDeliveryAt ?? this.estimatedDeliveryAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      routePoints: routePoints ?? this.routePoints,
      userLocation: userLocation ?? this.userLocation,
    );
  }
}
