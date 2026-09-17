import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/notifications/data/client/notification_api_client.dart';
import 'package:flowrist/shared/notifications/data/data_sources/contract/remote/notification_remote_datasource.dart';
import 'package:flowrist/shared/notifications/data/models/update_fcm_token_request.dart';
import 'package:flowrist/shared/notifications/data/models/update_notification_status_request.dart';
import 'package:flowrist/shared/notifications/data/models/update_notification_status_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final NotificationApiClient _apiService;

  NotificationRemoteDataSourceImpl(this._apiService);

  @override
  Future<void> updateFcmToken(UpdateFcmTokenRequest request) async {
    await _apiService.updateFcmToken(request);
  }

  @override
  Future<BaseResponse<UpdateNotificationStatusResponseModel>>
  updateNotificationStatus({
    required String deviceId,
    required UpdateNotificationStatusRequest request,
  }) async {
    try {
      final response = await _apiService.updateNotificationStatus(
        deviceId,
        request,
      );

      if (!response.status || response.data == null) {
        return ErrorResponse<UpdateNotificationStatusResponseModel>(
          response.message,
        );
      }

      return SuccessResponse<UpdateNotificationStatusResponseModel>(
        response.data!,
      );
    } on Exception catch (e) {
      return ApiErrorHandler.handleException(e);
    }
  }
}
