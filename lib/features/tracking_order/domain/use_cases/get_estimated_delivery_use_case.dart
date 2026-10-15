import 'package:flowrist/features/tracking_order/domain/repositories/tracking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetEstimatedDeliveryUseCase {
  final TrackingRepository _repository;

  GetEstimatedDeliveryUseCase(this._repository);

  Future<DateTime?> call() {
    return _repository.getEstimatedDeliveryAt();
  }
}
