import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/shared/domain/entities/city_entity.dart';
import 'package:injectable/injectable.dart';

import '../repositories/add_address_repository.dart';

@injectable
class GetCitiesUseCase {
  final AddAddressRepository _addAddressRepository;

  GetCitiesUseCase(this._addAddressRepository);

  Future<BaseResponse<List<CityEntity>>> call(int governorateId) async {
    return await _addAddressRepository.getCities(governorateId);
  }
}
