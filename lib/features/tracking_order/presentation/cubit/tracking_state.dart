import 'package:equatable/equatable.dart';
import '../../domain/entities/order_tracking_entity.dart';

class TrackingState extends Equatable {
  final bool isLoading;
  final bool isConfirmingDelivery;
  final bool isDeliveryConfirmed;
  final String? errorMessage;
  final OrderTrackingEntity? tracking;
  final DateTime? estimatedDeliveryAt;
  final DateTime? lastUpdatedAt;

  const TrackingState({
    this.isLoading = false,
    this.isConfirmingDelivery = false,
    this.isDeliveryConfirmed = false,
    this.errorMessage,
    this.tracking,
    this.estimatedDeliveryAt,
    this.lastUpdatedAt,
  });

  TrackingState copyWith({
    bool? isLoading,
    bool? isConfirmingDelivery,
    bool? isDeliveryConfirmed,
    String? errorMessage,
    OrderTrackingEntity? tracking,
    DateTime? estimatedDeliveryAt,
    DateTime? lastUpdatedAt,
  }) {
    return TrackingState(
      isLoading: isLoading ?? this.isLoading,
      isConfirmingDelivery: isConfirmingDelivery ?? this.isConfirmingDelivery,
      isDeliveryConfirmed: isDeliveryConfirmed ?? this.isDeliveryConfirmed,
      errorMessage: errorMessage,
      tracking: tracking ?? this.tracking,
      estimatedDeliveryAt: estimatedDeliveryAt ?? this.estimatedDeliveryAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isConfirmingDelivery,
    isDeliveryConfirmed,
    errorMessage,
    tracking,
    estimatedDeliveryAt,
    lastUpdatedAt,
  ];
}
