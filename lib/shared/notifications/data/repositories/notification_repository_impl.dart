import 'package:flowrist/shared/notifications/data/data_sources/contract/remote/notification_remote_datasource.dart';
import 'package:flowrist/shared/notifications/data/models/update_fcm_token_request.dart';
import 'package:flowrist/shared/notifications/data/models/update_notification_status_request.dart';
import 'package:flowrist/shared/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl
    implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> updateFcmToken(
    UpdateFcmTokenRequest request,
  ) async {
    await _remoteDataSource.updateFcmToken(request);
  }

   @override
  Future<void> updateNotificationStatus({
    required String deviceId,
    required UpdateNotificationStatusRequest request,
  }) {
    return _remoteDataSource.updateNotificationStatus(
      deviceId: deviceId,
      request: request,
    );
  }
}