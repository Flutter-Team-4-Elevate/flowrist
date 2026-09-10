import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/logout_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/logout_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api_client.g.dart';

@singleton
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @POST(Endpoints.logout)
  Future<LogoutResponseDto> logout(@Body() LogoutRequestDto request);
}
