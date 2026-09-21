import 'package:equatable/equatable.dart';

class TrackingUpdateEntity extends Equatable {
  final String orderId;
  final String? status;

  const TrackingUpdateEntity({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}
