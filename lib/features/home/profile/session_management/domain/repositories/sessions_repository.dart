import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/session_management/domain/entities/session_entity.dart';

abstract interface class SessionsRepository {
  Future<BaseResponse<List<SessionEntity>>> getSessions();
  Future<BaseResponse<void>> revokeSession(String sessionId);
}
