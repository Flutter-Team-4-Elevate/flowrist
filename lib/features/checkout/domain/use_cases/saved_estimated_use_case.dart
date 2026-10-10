import 'package:flowrist/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveEstimatedDeliveryUseCase {
  final CheckoutRepository _repository;

  SaveEstimatedDeliveryUseCase(this._repository);

  Future<void> call(DateTime estimatedDeliveryAt) {
    return _repository.saveEstimatedDeliveryAt(estimatedDeliveryAt);
  }
}
