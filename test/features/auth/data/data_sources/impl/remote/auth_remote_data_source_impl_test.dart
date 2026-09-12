import 'package:flowrist/features/auth/data/client/auth_api_client.dart';
import 'package:flowrist/features/auth/data/data_sources/impl/remote/auth_remote_data_source_impl.dart';
import 'package:flowrist/features/auth/data/models/forget_password_request_dto.dart';
import 'package:flowrist/features/auth/data/models/forget_password_response_dto.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/data/models/register_response_dto.dart';
import 'package:flowrist/features/auth/data/models/reset_password_request_dto.dart';
import 'package:flowrist/features/auth/data/models/reset_password_response_dto.dart';
import 'package:flowrist/features/auth/data/models/verify_otp_request_dto.dart';
import 'package:flowrist/features/auth/data/models/verify_otp_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AuthApiClient])
import 'auth_remote_data_source_impl_test.mocks.dart';

void main() {
  late MockAuthApiClient mockApiClient;
  late AuthRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockApiClient = MockAuthApiClient();
    remoteDataSource = AuthRemoteDataSourceImpl(mockApiClient);
  });

  const tRequestDto = RegisterRequestDto(
    firstName: 'Ali',
    lastName: 'Ibrahim',
    email: 'ali@example.com',
    phone: '01000000000',
    gender: 0,
    password: 'Password123!',
    confirmPassword: 'Password123!',
    fcmToken: 'token',
    notificationStatus: 1,
  );

  const tResponseDto = RegisterResponseDto(
    message: 'Success',
    data: RegisterDataDto(token: 'jwt_token_example'),
  );

  group('register', () {
    test(
      'should call apiClient.register and return RegisterResponseDto on success',
          () async {
        when(
          mockApiClient.register(any),
        ).thenAnswer((_) async => tResponseDto);

        final result = await remoteDataSource.register(tRequestDto);

        expect(result, equals(tResponseDto));
        verify(mockApiClient.register(tRequestDto)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('should rethrow exception when apiClient.register fails', () async {
      when(
        mockApiClient.register(any),
      ).thenThrow(Exception('Server error'));

      expect(
            () => remoteDataSource.register(tRequestDto),
        throwsA(isA<Exception>()),
      );

      verify(mockApiClient.register(tRequestDto)).called(1);
    });
  });

  group('forgotPassword', () {
    const email = 'ali@example.com';

    const response = ForgetPasswordResponseDto(
      status: true,
      message: 'OTP sent successfully',
    );

    test(
      'should call apiClient.forgotPassword with correct email and return response',
          () async {
        when(
          mockApiClient.forgotPassword(any),
        ).thenAnswer((_) async => response);

        final result = await remoteDataSource.forgotPassword(
          email: email,
        );

        expect(result, equals(response));

        final captured = verify(
          mockApiClient.forgotPassword(captureAny),
        ).captured.single as ForgetPasswordRequestDto;

        expect(captured.email, equals(email));

        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should rethrow exception when apiClient.forgotPassword fails',
          () async {
        when(
          mockApiClient.forgotPassword(any),
        ).thenThrow(Exception('Server error'));

        expect(
              () => remoteDataSource.forgotPassword(email: email),
          throwsA(isA<Exception>()),
        );

        verify(mockApiClient.forgotPassword(any)).called(1);
      },
    );
  });

  group('verifyOtp', () {
    const email = 'ali@example.com';
    const otp = '123456';

    const response = VerifyOtpResponseDto(
      status: true,
      message: 'OTP verified successfully',
    );

    test(
      'should call apiClient.verifyOtp with correct email and otp',
          () async {
        when(
          mockApiClient.verifyOtp(any),
        ).thenAnswer((_) async => response);

        final result = await remoteDataSource.verifyOtp(
          email: email,
          otp: otp,
        );

        expect(result, equals(response));

        final captured = verify(
          mockApiClient.verifyOtp(captureAny),
        ).captured.single as VerifyOtpRequestDto;

        expect(captured.email, equals(email));
        expect(captured.otp, equals(otp));

        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should rethrow exception when apiClient.verifyOtp fails',
          () async {
        when(
          mockApiClient.verifyOtp(any),
        ).thenThrow(Exception('Server error'));

        expect(
              () => remoteDataSource.verifyOtp(
            email: email,
            otp: otp,
          ),
          throwsA(isA<Exception>()),
        );

        verify(mockApiClient.verifyOtp(any)).called(1);
      },
    );
  });

  group('resetPassword', () {
    const otpToken = '123456';
    const password = 'Password123!';
    const confirmPassword = 'Password123!';

    const response = ResetPasswordResponseDto(
      status: true,
      message: 'Password reset successfully',
    );

    test(
      'should call apiClient.resetPassword with correct parameters',
          () async {
        when(
          mockApiClient.resetPassword(any),
        ).thenAnswer((_) async => response);

        final result = await remoteDataSource.resetPassword(
          otpToken: otpToken,
          password: password,
          confirmPassword: confirmPassword,
        );

        expect(result, equals(response));

        final captured = verify(
          mockApiClient.resetPassword(captureAny),
        ).captured.single as ResetPasswordRequestDto;

        expect(captured.otpToken, equals(otpToken));
        expect(captured.password, equals(password));
        expect(captured.confirmPassword, equals(confirmPassword));

        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should rethrow exception when apiClient.resetPassword fails',
          () async {
        when(
          mockApiClient.resetPassword(any),
        ).thenThrow(Exception('Server error'));

        expect(
              () => remoteDataSource.resetPassword(
                otpToken: otpToken,
                password: password,
                confirmPassword: confirmPassword,
          ),
          throwsA(isA<Exception>()),
        );

        verify(mockApiClient.resetPassword(any)).called(1);
      },
    );
  });
}