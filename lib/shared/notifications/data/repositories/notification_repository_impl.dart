import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/shared/notifications/data/data_sources/contract/remote/notification_remote_datasource.dart';
import 'package:flowrist/shared/notifications/data/models/update_fcm_token_request.dart';
import 'package:flowrist/shared/notifications/data/models/update_notification_status_request.dart';
import 'package:flowrist/shared/notifications/data/models/update_notification_status_response_model.dart';
import 'package:flowrist/shared/notifications/domain/entities/update_notification_status_entity.dart';
import 'package:flowrist/shared/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  NotificationRepositoryImpl(
    this._remoteDataSource,
    this._secureStorage,
  );

  @override
  Future<void> updateFcmToken(
    UpdateFcmTokenRequest request,
  ) async {
    await _remoteDataSource.updateFcmToken(request);
  }

  @override
  Future<BaseResponse<UpdateNotificationStatusEntity>>
      updateNotificationStatus({
    required String deviceId,
    required UpdateNotificationStatusRequest request,
  }) async {
    final response = await _remoteDataSource.updateNotificationStatus(
      deviceId: deviceId,
      request: request,
    );

    switch (response) {
      case SuccessResponse<UpdateNotificationStatusResponseModel>():
        final entity = response.data?.toEntity();

        if (entity == null) {
          return ErrorResponse(
            'Notification status data is empty',
          );
        }

        await _secureStorage.save(
          Endpoints.notificationsEnabled,
          entity.notificationsEnabled.toString(),
        );

        return SuccessResponse(entity);

      case ErrorResponse<UpdateNotificationStatusResponseModel>():
        return ErrorResponse(
          response.errorMessage,
        );
    }
  }

  @override
  Future<bool> getNotificationStatus() async {
    final value = await _secureStorage.get(
      Endpoints.notificationsEnabled,
    );

    if (value.isEmpty) {
      return true;
    }

    return value == 'true';
  }
}