import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/shared/notifications/data/models/update_fcm_token_request.dart';
import 'package:flowrist/shared/notifications/data/models/update_notification_status_request.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class NotificationApiClient {
  @factoryMethod
  factory NotificationApiClient(Dio dio) = _NotificationApiClient;

  @PUT(Endpoints.updateFcmToken)
  Future<void> updateFcmToken(@Body() UpdateFcmTokenRequest request);

  @PUT(Endpoints.updateNotificationStatus)
Future<void> updateNotificationStatus(
  @Path('deviceId') String deviceId,
  @Body() UpdateNotificationStatusRequest request,
);
}
