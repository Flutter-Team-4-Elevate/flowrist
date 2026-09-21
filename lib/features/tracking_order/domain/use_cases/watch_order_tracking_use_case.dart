import 'package:injectable/injectable.dart';

import '../entities/order_tracking_entity.dart';
import '../repositories/tracking_repository.dart';

@injectable
class WatchOrderTrackingUseCase {
  final TrackingRepository _repository;

  WatchOrderTrackingUseCase(this._repository);

  Stream<OrderTrackingEntity> call(String orderId) {
    return _repository.watchOrderTracking(orderId);
  }
}
