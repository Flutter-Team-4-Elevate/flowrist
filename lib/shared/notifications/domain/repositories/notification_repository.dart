import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/notifications/data/models/update_fcm_token_request.dart';
import 'package:flowrist/shared/notifications/data/models/update_notification_status_request.dart';
import 'package:flowrist/shared/notifications/domain/entities/update_notification_status_entity.dart';

abstract interface class NotificationRepository {
  Future<void> updateFcmToken(
    UpdateFcmTokenRequest request,
  );

   Future<BaseResponse<UpdateNotificationStatusEntity>> updateNotificationStatus({
    required String deviceId,
    required UpdateNotificationStatusRequest request,
  });
  Future<bool> getNotificationStatus();
}