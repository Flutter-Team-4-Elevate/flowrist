import 'package:equatable/equatable.dart';

import '../../domain/entities/order_tracking_entity.dart';

class TrackingState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final OrderTrackingEntity? tracking;

  const TrackingState({
    this.isLoading = false,
    this.errorMessage,
    this.tracking,
  });

  TrackingState copyWith({
    bool? isLoading,
    String? errorMessage,
    OrderTrackingEntity? tracking,
  }) {
    return TrackingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      tracking: tracking ?? this.tracking,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, tracking];
}
