import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';
import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RequestLocationPermissionUseCase {
  final LocationRepository _locationRepository;

  RequestLocationPermissionUseCase(this._locationRepository);

  Future<PermissionStatusEntity> call() async {
    return await _locationRepository.requestLocationPermission();
  }
}
