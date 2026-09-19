import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/shared/addresses/domain/repositories/addresses_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllUserAddressesUseCase {
  final AddressesRepository _repository;

  GetAllUserAddressesUseCase(this._repository);

  Future<BaseResponse<List<AddressEntity>>> call() {
    return _repository.getAllUserAddresses();
  }
}
