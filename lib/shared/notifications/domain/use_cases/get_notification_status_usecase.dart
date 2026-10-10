import 'package:flowrist/shared/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetNotificationStatusUseCase {
  final NotificationRepository _repository;

  GetNotificationStatusUseCase(this._repository);

  Future<bool> call() {
    return _repository.getNotificationStatus();
  }
}
