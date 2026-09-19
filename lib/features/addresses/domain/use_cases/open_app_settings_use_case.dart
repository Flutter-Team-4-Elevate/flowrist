import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class OpenAppSettingsUseCase {
  final LocationRepository _locationRepository;

  OpenAppSettingsUseCase(this._locationRepository);

  Future<bool> call() async {
    return await _locationRepository.openAppSettings();
  }
}
