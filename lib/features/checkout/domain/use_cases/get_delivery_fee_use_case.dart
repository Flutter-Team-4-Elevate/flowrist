import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/delivery_fee_entity.dart';
import 'package:flowrist/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetDeliveryFeeUseCase {
  final CheckoutRepository _repository;

  GetDeliveryFeeUseCase(this._repository);

  Future<BaseResponse<DeliveryFeeEntity>> call({
    required String addressId,
    required String cartId,
  }) {
    return _repository.getDeliveryFee(addressId: addressId, cartId: cartId);
  }
}
