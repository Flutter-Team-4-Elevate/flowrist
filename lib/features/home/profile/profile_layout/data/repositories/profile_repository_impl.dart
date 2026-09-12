import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/data_sources/contract/profile_remote_data_source.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/mapper/user_profile_mapper.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/change_password_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/logout_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/update_profile_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/entities/user_profile_entity.dart';
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
    } on Exception catch (e) {
      await _sessionService.clearSession();
      return ApiErrorHandler.handleException<void>(e);
    } catch (_) {
      await _sessionService.clearSession();
      return ErrorResponse('An unexpected error occurred');
    }
  }

  @override
  Future<BaseResponse<UserProfileEntity>> getProfile() async {
    try {
      final response = await _remoteDataSource.getProfile();
      if (response.status == true && response.data != null) {
        return SuccessResponse(response.data!.toEntity());
      }
      return ErrorResponse(response.message ?? 'Failed to load profile');
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<UserProfileEntity>(e);
    } catch (_) {
      return ErrorResponse('An unexpected error occurred');
    }
  }

  @override
  Future<BaseResponse<UserProfileEntity>> updateProfile(
    UpdateProfileRequestDto request,
  ) async {
    try {
      final response = await _remoteDataSource.updateProfile(request);
      if (response.status == true && response.data != null) {
        return SuccessResponse(response.data!.toEntity());
      }
      return ErrorResponse(response.message ?? 'Failed to update profile');
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<UserProfileEntity>(e);
    } catch (_) {
      return ErrorResponse('An unexpected error occurred');
    }
  }

  @override
  Future<BaseResponse<void>> changePassword(
    ChangePasswordRequestDto request,
  ) async {
    try {
      final response = await _remoteDataSource.changePassword(request);
      if (response.status == true) {
        await _sessionService.clearSession();
        return SuccessResponse(null);
      }
      return ErrorResponse(response.message ?? 'Failed to change password');
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<void>(e);
    } catch (_) {
      return ErrorResponse('An unexpected error occurred');
    }
  }
}
