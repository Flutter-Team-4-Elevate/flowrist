import 'package:json_annotation/json_annotation.dart';

part 'update_fcm_token_request.g.dart';

@JsonSerializable()
class UpdateFcmTokenRequest {
  final String deviceId;
  final String fcmToken;

  const UpdateFcmTokenRequest({
    required this.deviceId,
    required this.fcmToken,
  });

  factory UpdateFcmTokenRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$UpdateFcmTokenRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateFcmTokenRequestToJson(this);
}