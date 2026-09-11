import 'package:flowrist/shared/notifications/data/models/update_fcm_token_request.dart';
import 'package:flowrist/shared/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateFcmTokenUseCase {
  final NotificationRepository _repository;

  UpdateFcmTokenUseCase(this._repository);

  Future<void> call({
    required String deviceId,
    required String fcmToken,
  }) async {
    final request = UpdateFcmTokenRequest(
      deviceId: deviceId,
      fcmToken: fcmToken,
    );

    await _repository.updateFcmToken(request);
  }
}