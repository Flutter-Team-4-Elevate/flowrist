import 'package:flowrist/shared/notifications/data/models/update_fcm_token_request.dart';

abstract class NotificationRemoteDataSource {
  Future<void> updateFcmToken(
    UpdateFcmTokenRequest request,
  );
}