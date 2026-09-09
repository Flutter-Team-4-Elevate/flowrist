import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/session_management/domain/entities/session_entity.dart';
import 'package:flowrist/features/home/profile/session_management/domain/repositories/sessions_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSessionsUseCase {
  final SessionsRepository _repository;

  GetSessionsUseCase(this._repository);

  Future<BaseResponse<List<SessionEntity>>> call() async {
    return await _repository.getSessions();
  }
}
