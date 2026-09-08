import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/features/auth/data/data_sources/contract/remote/auth_remote_data_source.dart';
import 'package:flowrist/features/auth/data/mapper/auth_mapper.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/data/request/login_request.dart';
import 'package:flowrist/features/auth/domain/entities/login_entity.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';
import 'package:flowrist/features/auth/domain/params/login_params.dart';
import 'package:flowrist/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SessionService _sessionService;

  AuthRepositoryImpl(this._remoteDataSource, this._sessionService);

  @override
  Future<BaseResponse<UserEntity>> register(RegisterRequestDto request) async {
    try {
      final responseDto = await _remoteDataSource.register(request);
      final entity = AuthMapper.toUserEntity(responseDto);
      return SuccessResponse<UserEntity>(entity);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<UserEntity>(e);
    }
  }

  @override
  Future<BaseResponse<LoginEntity>> login(
    LoginParams params,
    bool rememberMe,
  ) async {
    try {
      final request = LoginRequest(
        email: params.email,
        password: params.password,
        fcmToken: params.fcmToken,
      );
      final response = await _remoteDataSource.login(request);
      final loginEntity = response.toEntity();

      await _sessionService.setRememberMe(rememberMe);
      await _sessionService.setGuestMode(false);
      await _sessionService.saveToken(
        loginEntity.token,
        rememberMe: rememberMe,
      );

      return SuccessResponse(loginEntity);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<LoginEntity>(e);
    }
  }

  @override
  Future<BaseResponse<void>> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);

      return SuccessResponse(null);
    } on Exception catch (exception) {
      return ApiErrorHandler.handleException<void>(exception);
    }
  }

  @override
  Future<BaseResponse<void>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        email: email,
        newPassword: newPassword,
      );

      return SuccessResponse(null);
    } on Exception catch (exception) {
      return ApiErrorHandler.handleException<void>(exception);
    }
  }

  @override
  Future<BaseResponse<void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await _remoteDataSource.verifyOtp(email: email, otp: otp);

      return SuccessResponse(null);
    } on Exception catch (exception) {
      return ApiErrorHandler.handleException<void>(exception);
    }
  }
}
