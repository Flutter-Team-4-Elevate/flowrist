import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RequestLocationServiceUseCase {
  final LocationRepository _locationRepository;

  RequestLocationServiceUseCase(this._locationRepository);

  Future<bool> call() async {
    return await _locationRepository.requestLocationService();
  }
}
