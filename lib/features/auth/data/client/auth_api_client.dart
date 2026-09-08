import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/data/models/register_response_dto.dart';
import 'package:flowrist/features/auth/data/models/login_response.dart';
import 'package:flowrist/features/auth/data/request/login_request.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/forget_password_request_dto.dart';
import '../models/forget_password_response_dto.dart';
import '../models/reset_password_request_dto.dart';
import '../models/reset_password_response_dto.dart';
import '../models/verify_otp_request_dto.dart';
import '../models/verify_otp_response_dto.dart';

part 'auth_api_client.g.dart';

@singleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(Endpoints.register)
  Future<RegisterResponseDto> register(@Body() RegisterRequestDto request);

  @POST("api/identity/auth/login")
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST(Endpoints.forgetPassword)
  Future<ForgetPasswordResponseDto> forgotPassword(
    @Body() ForgetPasswordRequestDto request,
  );

  @POST(Endpoints.verifyOTP)
  Future<VerifyOtpResponseDto> verifyOtp(@Body() VerifyOtpRequestDto request);

  @POST(Endpoints.resetPassword)
  Future<ResetPasswordResponseDto> resetPassword(
    @Body() ResetPasswordRequestDto request,
  );
}
