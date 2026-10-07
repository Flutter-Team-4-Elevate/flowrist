import 'package:flowrist/features/tracking_order/domain/repositories/tracking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateOrderTrackingNotificationUseCase {
  final TrackingRepository _repository;

  UpdateOrderTrackingNotificationUseCase(this._repository);

  Future<void> call({
    required String orderNumber,
    required String status,
    required int completedSteps,
    required int totalSteps,
  }) async {
    await _repository.showOrderTrackingNotification(
      orderNumber: orderNumber,
      status: status,
      completedSteps: completedSteps,
      totalSteps: totalSteps,
    );
  }
}
