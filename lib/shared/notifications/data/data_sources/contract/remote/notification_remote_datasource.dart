import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/notifications/data/models/update_fcm_token_request.dart';
import 'package:flowrist/shared/notifications/data/models/update_notification_status_request.dart';
import 'package:flowrist/shared/notifications/data/models/update_notification_status_response_model.dart';

abstract interface class NotificationRemoteDataSource {
  Future<void> updateFcmToken(UpdateFcmTokenRequest request);

  Future<BaseResponse<UpdateNotificationStatusResponseModel>>updateNotificationStatus({
    required String deviceId,
    required UpdateNotificationStatusRequest request,
  });
}
