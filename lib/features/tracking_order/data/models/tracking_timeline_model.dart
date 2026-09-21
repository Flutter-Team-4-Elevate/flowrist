import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/tracking_timeline_entity.dart';

part 'tracking_timeline_model.g.dart';

@JsonSerializable()
class TrackingTimelineModel {
  final String status;
  final bool isCompleted;
  final bool isCurrent;
  final DateTime? occurredAt;

  const TrackingTimelineModel({
    required this.status,
    required this.isCompleted,
    required this.isCurrent,
    this.occurredAt,
  });

  factory TrackingTimelineModel.fromJson(Map<String, dynamic> json) =>
      _$TrackingTimelineModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingTimelineModelToJson(this);

  TrackingTimelineEntity toEntity() {
    return TrackingTimelineEntity(
      status: status,
      isCompleted: isCompleted,
      isCurrent: isCurrent,
      occurredAt: occurredAt,
    );
  }
}
