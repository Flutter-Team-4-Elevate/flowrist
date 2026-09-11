import 'package:flowrist/shared/notifications/data/client/notification_api_client.dart';
import 'package:flowrist/shared/notifications/data/data_sources/contract/remote/notification_remote_datasource.dart';
import 'package:flowrist/shared/notifications/data/models/update_fcm_token_request.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl
    implements NotificationRemoteDataSource {
  final NotificationApiClient _apiService;

  NotificationRemoteDataSourceImpl(this._apiService);

  @override
  Future<void> updateFcmToken(
    UpdateFcmTokenRequest request,
  ) async {
    await _apiService.updateFcmToken(request);
  }
}