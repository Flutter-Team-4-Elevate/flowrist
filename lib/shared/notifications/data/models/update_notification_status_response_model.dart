import 'package:flowrist/shared/notifications/domain/entities/update_notification_status_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'update_notification_status_response_model.g.dart';

@JsonSerializable()
class UpdateNotificationStatusResponseModel {
  final String deviceId;
  final bool notificationsEnabled;

  const UpdateNotificationStatusResponseModel({
    required this.deviceId,
    required this.notificationsEnabled,
  });

  factory UpdateNotificationStatusResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$UpdateNotificationStatusResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateNotificationStatusResponseModelToJson(this);

  UpdateNotificationStatusEntity toEntity() {
    return UpdateNotificationStatusEntity(
      deviceId: deviceId,
      notificationsEnabled: notificationsEnabled,
    );
  }
}