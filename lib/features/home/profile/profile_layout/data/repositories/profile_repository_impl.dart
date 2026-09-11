import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/data_sources/contract/profile_remote_data_source.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/logout_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final SessionService _sessionService;

  ProfileRepositoryImpl(this._remoteDataSource, this._sessionService);

  @override
  Future<BaseResponse<void>> logout() async {
    try {
      final refreshToken = await _sessionService.getRefreshToken();
      await _remoteDataSource.logout(
        LogoutRequestDto(refreshToken: refreshToken),
      );
      await _sessionService.clearSession();
      return SuccessResponse(null);
    } catch (e) {
      await _sessionService.clearSession();
      return ErrorResponse(e.toString());
    }
  }
}
