import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/addresses/domain/entities/default_address_entity.dart';
import 'package:flowrist/shared/addresses/domain/repositories/addresses_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetDefaultAddressUseCase {
  final AddressesRepository _repository;

  SetDefaultAddressUseCase(this._repository);

  Future<BaseResponse<DefaultAddressEntity>> call(String addressId) {
    return _repository.setDefaultAddress(addressId);
  }
}
