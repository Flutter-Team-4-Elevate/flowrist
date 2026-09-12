import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/domain/entities/governorate_entity.dart';
import 'package:injectable/injectable.dart';

import '../repositories/add_address_repository.dart';

@injectable
class GetGovernoratesUseCase {
  final AddAddressRepository _addAddressRepository;

  GetGovernoratesUseCase(this._addAddressRepository);

  Future<BaseResponse<List<GovernorateEntity>>> call() async {
    return await _addAddressRepository.getGovernorates();
  }
}
