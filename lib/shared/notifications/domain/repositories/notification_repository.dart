import 'package:flowrist/shared/notifications/data/models/update_fcm_token_request.dart';
import 'package:flowrist/shared/notifications/data/models/update_notification_status_request.dart';

abstract class NotificationRepository {
  Future<void> updateFcmToken(
    UpdateFcmTokenRequest request,
  );

  Future<void> updateNotificationStatus({
    required String deviceId,
    required UpdateNotificationStatusRequest request,
  });
}