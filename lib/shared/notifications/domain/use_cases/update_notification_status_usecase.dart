import 'package:flowrist/shared/notifications/data/models/update_notification_status_request.dart';
import 'package:flowrist/shared/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateNotificationStatusUseCase {
  final NotificationRepository _repository;

  UpdateNotificationStatusUseCase(this._repository);

  Future<void> call({
    required String deviceId,
    required bool enabled,
  }) async {
    final request = UpdateNotificationStatusRequest(
      enabled: enabled,
    );

    await _repository.updateNotificationStatus(
      deviceId: deviceId,
      request: request,
    );
  }
}