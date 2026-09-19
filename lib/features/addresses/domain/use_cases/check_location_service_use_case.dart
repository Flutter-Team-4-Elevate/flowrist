import 'package:flowrist/features/addresses/domain/entities/service_status_entity.dart';
import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckLocationServiceUseCase {
  final LocationRepository _locationRepository;

  CheckLocationServiceUseCase(this._locationRepository);

  Future<ServiceStatusEntity> call() async {
    return await _locationRepository.checkLocationService();
  }
}
