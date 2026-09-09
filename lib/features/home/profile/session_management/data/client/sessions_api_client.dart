import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/home/profile/session_management/data/models/response/session_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'sessions_api_client.g.dart';

@singleton
@RestApi()
abstract class SessionsApiClient {
  @factoryMethod
  factory SessionsApiClient(Dio dio) = _SessionsApiClient;

  @GET(Endpoints.sessions)
  Future<SessionsResponseDto> getSessions();

  @DELETE('${Endpoints.sessions}/{sessionId}')
  Future<RevokeSessionResponseDto> revokeSession(
    @Path('sessionId') String sessionId,
  );
}