import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserCurrentLocationUseCase {
  final LocationRepository _locationRepository;

  GetUserCurrentLocationUseCase(this._locationRepository);

  Future<BaseResponse<(CoordinatesEntity, String?)>> call() async {
    return await _locationRepository.fetchUserCurrentLocation();
  }
}
