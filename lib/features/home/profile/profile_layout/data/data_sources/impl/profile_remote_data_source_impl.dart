import 'package:flowrist/features/home/profile/profile_layout/data/client/profile_api_client.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/data_sources/contract/profile_remote_data_source.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/change_password_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/logout_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/update_profile_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/change_password_response_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/logout_response_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/user_profile_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiClient _apiClient;
  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LogoutResponseDto> logout(LogoutRequestDto request) async {
    return await _apiClient.logout(request);
  }

  @override
  Future<UserProfileResponseDto> getProfile() async {
    return await _apiClient.getProfile();
  }

  @override
  Future<UserProfileResponseDto> updateProfile(
    UpdateProfileRequestDto request,
  ) async {
    return await _apiClient.updateProfile(request);
  }

  @override
  Future<ChangePasswordResponseDto> changePassword(
    ChangePasswordRequestDto request,
  ) async {
    return await _apiClient.changePassword(request);
  }
}
