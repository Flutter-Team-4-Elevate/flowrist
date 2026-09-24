import 'package:flowrist/features/home/profile/session_management/data/client/sessions_api_client.dart';
import 'package:flowrist/features/home/profile/session_management/data/data_sources/contract/sessions_remote_data_source.dart';
import 'package:flowrist/features/home/profile/session_management/data/models/response/session_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SessionsRemoteDataSource)
class SessionsRemoteDataSourceImpl implements SessionsRemoteDataSource {
  final SessionsApiClient _apiClient;

  SessionsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<SessionsResponseDto> getSessions() async {
    return await _apiClient.getSessions();
  }

  @override
  Future<RevokeSessionResponseDto> revokeSession(String sessionId) async {
    return await _apiClient.revokeSession(sessionId);
  }
}
