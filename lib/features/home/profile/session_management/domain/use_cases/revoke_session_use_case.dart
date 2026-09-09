import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/session_management/domain/repositories/sessions_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RevokeSessionUseCase {
  final SessionsRepository _repository;

  RevokeSessionUseCase(this._repository);

  Future<BaseResponse<void>> call(String sessionId) async {
    return await _repository.revokeSession(sessionId);
  }
}
