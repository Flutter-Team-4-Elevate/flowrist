import 'package:flowrist/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/add_address_request_model.dart';
import '../repositories/add_address_repository.dart';

@injectable
class UpdateAddressUseCase {
  final AddAddressRepository _repository;

  UpdateAddressUseCase(this._repository);

  Future<BaseResponse<void>> call(
    String addressId,
    AddAddressRequestModel request,
  ) {
    return _repository.updateAddress(addressId, request);
  }
}
