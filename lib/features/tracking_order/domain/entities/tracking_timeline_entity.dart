import 'package:equatable/equatable.dart';

class TrackingTimelineEntity extends Equatable {
  final String status;
  final bool isCompleted;
  final bool isCurrent;
  final DateTime? occurredAt;

  const TrackingTimelineEntity({
    required this.status,
    required this.isCompleted,
    required this.isCurrent,
    this.occurredAt,
  });

  @override
  List<Object?> get props => [status, isCompleted, isCurrent, occurredAt];
}
