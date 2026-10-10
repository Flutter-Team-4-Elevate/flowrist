import 'package:flowrist/features/home/profile/session_management/data/models/response/session_response_dto.dart';

abstract interface class SessionsRemoteDataSource {
  Future<SessionsResponseDto> getSessions();
  Future<RevokeSessionResponseDto> revokeSession(String sessionId);
}
