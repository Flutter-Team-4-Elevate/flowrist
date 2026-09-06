import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/addresses/domain/repositories/addresses_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAddressUseCase {
  final AddressesRepository _repository;

  DeleteAddressUseCase(this._repository);

  Future<BaseResponse<String>> call(String addressId) {
    return _repository.deleteAddress(addressId);
  }
}
