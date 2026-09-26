import 'package:equatable/equatable.dart';

import '../../domain/entities/order_tracking_entity.dart';

class TrackingState extends Equatable {
  final bool isLoading;
  final bool isConfirmingDelivery;
  final bool isDeliveryConfirmed;
  final String? errorMessage;
  final OrderTrackingEntity? tracking;

  const TrackingState({
    this.isLoading = false,
    this.isConfirmingDelivery = false,
    this.isDeliveryConfirmed = false,
    this.errorMessage,
    this.tracking,
  });

  TrackingState copyWith({
    bool? isLoading,
    bool? isConfirmingDelivery,
    bool? isDeliveryConfirmed,
    String? errorMessage,
    OrderTrackingEntity? tracking,
  }) {
    return TrackingState(
      isLoading: isLoading ?? this.isLoading,
      isConfirmingDelivery: isConfirmingDelivery ?? this.isConfirmingDelivery,
      isDeliveryConfirmed: isDeliveryConfirmed ?? this.isDeliveryConfirmed,
      errorMessage: errorMessage,
      tracking: tracking ?? this.tracking,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isConfirmingDelivery,
    isDeliveryConfirmed,
    errorMessage,
    tracking,
  ];
}
