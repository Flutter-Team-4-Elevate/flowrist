import 'package:json_annotation/json_annotation.dart';
import 'update_notification_status_response_model.dart';

part 'update_notification_status_api_response.g.dart';

@JsonSerializable()
class UpdateNotificationStatusApiResponse {
  final bool status;
  final int code;
  final String message;
  final UpdateNotificationStatusResponseModel? data;

  const UpdateNotificationStatusApiResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory UpdateNotificationStatusApiResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateNotificationStatusApiResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateNotificationStatusApiResponseToJson(this);
}
