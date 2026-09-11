import 'package:flowrist/features/home/profile/profile_layout/data/models/request/logout_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/logout_response_dto.dart';

abstract interface class ProfileRemoteDataSource {
  Future<LogoutResponseDto> logout(LogoutRequestDto request);
}
