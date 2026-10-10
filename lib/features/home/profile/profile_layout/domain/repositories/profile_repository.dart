import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/change_password_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/update_profile_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/entities/user_profile_entity.dart';

abstract interface class ProfileRepository {
  Future<BaseResponse<void>> logout();
  Future<BaseResponse<UserProfileEntity>> getProfile();
  Future<BaseResponse<UserProfileEntity>> updateProfile(
    UpdateProfileRequestDto request,
  );
  Future<BaseResponse<void>> changePassword(ChangePasswordRequestDto request);
}
