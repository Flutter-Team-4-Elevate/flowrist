import 'package:flowrist/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../entities/add_address_request_entity.dart';
import '../repositories/add_address_repository.dart';

@injectable
class UpdateAddressUseCase {
  final AddAddressRepository _repository;

  UpdateAddressUseCase(this._repository);

  Future<BaseResponse<void>> call(
    String addressId,
    AddAddressRequestEntity request,
  ) {
    return _repository.updateAddress(addressId, request);
  }
}
