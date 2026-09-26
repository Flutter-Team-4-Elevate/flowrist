import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/tracking_order/domain/repositories/tracking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ConfirmDeliveryUseCase {
  final TrackingRepository _repository;

  ConfirmDeliveryUseCase(this._repository);

  Future<BaseResponse<dynamic>> call(String orderId) {
    return _repository.confirmDelivery(orderId);
  }
}