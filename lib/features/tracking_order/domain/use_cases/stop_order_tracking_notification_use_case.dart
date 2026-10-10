import 'package:flowrist/features/tracking_order/domain/repositories/tracking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class StopOrderTrackingNotificationUseCase {
  final TrackingRepository _repository;

  StopOrderTrackingNotificationUseCase(this._repository);

  Future<void> call() async {
    await _repository.stopOrderTrackingNotification();
  }
}
