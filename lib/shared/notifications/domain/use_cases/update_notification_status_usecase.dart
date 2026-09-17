import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/notifications/data/models/update_notification_status_request.dart';
import 'package:flowrist/shared/notifications/domain/entities/update_notification_status_entity.dart';
import 'package:flowrist/shared/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateNotificationStatusUseCase {
  final NotificationRepository _repository;

  UpdateNotificationStatusUseCase(this._repository);

  Future<BaseResponse<UpdateNotificationStatusEntity>> call({
    required String deviceId,
    required bool enabled,
  }) async {
    final request = UpdateNotificationStatusRequest(enabled: enabled);

    return await _repository.updateNotificationStatus(
      deviceId: deviceId,
      request: request,
    );
  }
}
