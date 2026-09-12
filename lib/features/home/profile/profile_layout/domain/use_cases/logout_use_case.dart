import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase {
  final ProfileRepository _repository;

  LogoutUseCase(this._repository);

  Future<BaseResponse<void>> call() async {
    return await _repository.logout();
  }
}
