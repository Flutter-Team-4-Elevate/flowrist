import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAddressFromLocationUseCase {
  final LocationRepository _locationRepository;

  GetAddressFromLocationUseCase(this._locationRepository);

  Future<BaseResponse<String?>> call(CoordinatesEntity location) async {
    return await _locationRepository.getAddressFromLocation(location);
  }
}
