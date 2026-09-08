import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';
import 'package:flowrist/features/auth/domain/entities/login_entity.dart';
import 'package:flowrist/features/auth/domain/params/login_params.dart';

abstract interface class AuthRepository {
  Future<BaseResponse<UserEntity>> register(RegisterRequestDto request);
  Future<BaseResponse<LoginEntity>> login(LoginParams params, bool rememberMe);
  Future<BaseResponse<void>> forgotPassword({required String email});

  Future<BaseResponse<void>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<BaseResponse<void>> resetPassword({
    required String email,
    required String newPassword,
  });
}
