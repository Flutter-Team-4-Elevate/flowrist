import 'package:flowrist/features/home/profile/profile_layout/data/models/request/change_password_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/logout_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/update_profile_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/change_password_response_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/logout_response_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/user_profile_dto.dart';

abstract interface class ProfileRemoteDataSource {
  Future<LogoutResponseDto> logout(LogoutRequestDto request);
  Future<UserProfileResponseDto> getProfile();
  Future<UserProfileResponseDto> updateProfile(UpdateProfileRequestDto request);
  Future<ChangePasswordResponseDto> changePassword(
    ChangePasswordRequestDto request,
  );
}
