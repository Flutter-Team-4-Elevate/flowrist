import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/device_id/device_id_services.dart';
import 'package:flowrist/config/notifications/notification_service.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/features/auth/data/data_sources/contract/remote/auth_remote_data_source.dart';
import 'package:flowrist/features/auth/data/models/login_response.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/data/models/register_response_dto.dart';
import 'package:flowrist/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flowrist/features/auth/data/request/login_request.dart';
import 'package:flowrist/features/auth/domain/entities/login_entity.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';
import 'package:flowrist/features/auth/domain/params/login_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([
  AuthRemoteDataSource,
  SessionService,
  DeviceIdService,
  PushNotificationsServices,
])
void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockSessionService mockSessionService;
  late MockDeviceIdService mockDeviceIdService;
  late MockPushNotificationsServices mockPushNotificationsServices;

  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockSessionService = MockSessionService();
    mockDeviceIdService = MockDeviceIdService();
    mockPushNotificationsServices = MockPushNotificationsServices();

    repository = AuthRepositoryImpl(
      mockRemoteDataSource,
      mockSessionService,
      mockDeviceIdService,
      mockPushNotificationsServices,
    );
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

  const tUserDto = UserDto(
    id: '123',
    name: 'Ali Ibrahim',
    email: 'ali@example.com',
    phone: '01000000000',
  );

  const tResponseDto = RegisterResponseDto(
    message: 'Success',
    data: RegisterDataDto(user: tUserDto, token: 'jwt_token_example'),
  );

  const tLoginParams = LoginParams(
    email: 'ali@example.com',
    password: 'Password123!',
  );

  final tLoginResponse = LoginResponse(
    status: true,
    code: 200,
    message: 'Success',
    data: LoginData(
      user: LoginUser(
        id: '123',
        email: 'ali@example.com',
        phone: '01000000000',
        name: 'Ali Ibrahim',
        roles: const ['user'],
        createdAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
        gender: 'male',
        notificationStatus: '1',
      ),
      token: 'jwt_token_123',
      refreshToken: 'refresh_token_123',
    ),
  );

  group('AuthRepositoryImpl - Register Tests', () {
    test(
      'should return SuccessResponse<UserEntity> when remote call is successful',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.register(any),
        ).thenAnswer((_) async => tResponseDto);

        // Act
        final result = await repository.register(tRequestDto);

        // Assert
        expect(result, isA<SuccessResponse<UserEntity>>());

        final successData = (result as SuccessResponse<UserEntity>).data;

        expect(successData?.id, equals('123'));

        verify(mockRemoteDataSource.register(tRequestDto)).called(1);

        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return FailureResponse when remote call throws an exception',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.register(any),
        ).thenThrow(Exception('Server error'));

        // Act
        final result = await repository.register(tRequestDto);

        // Assert
        expect(result, isNot(isA<SuccessResponse<UserEntity>>()));

        verify(mockRemoteDataSource.register(tRequestDto)).called(1);

        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('AuthRepositoryImpl - Login Tests', () {
    setUp(() {
      // These are required because AuthRepositoryImpl
      // gets them internally now.

      when(
        mockDeviceIdService.getDeviceId(),
      ).thenAnswer((_) async => 'test-device-id');

      when(
        mockPushNotificationsServices.getFcmToken(),
      ).thenAnswer((_) async => 'test-fcm-token');
    });

    test('should get deviceId and FCM token before login', () async {
      // Arrange
      when(
        mockRemoteDataSource.login(any),
      ).thenAnswer((_) async => tLoginResponse);

      when(mockSessionService.setRememberMe(any)).thenAnswer((_) async {});

      when(mockSessionService.setGuestMode(any)).thenAnswer((_) async {});

      when(
        mockSessionService.saveTokens(
          token: anyNamed('token'),
          refreshToken: anyNamed('refreshToken'),
          rememberMe: anyNamed('rememberMe'),
        ),
      ).thenAnswer((_) async {});

      // Act
      await repository.login(tLoginParams, true);

      // Assert
      verify(mockDeviceIdService.getDeviceId()).called(1);

      verify(mockPushNotificationsServices.getFcmToken()).called(1);

      verify(mockRemoteDataSource.login(any)).called(1);
    });

    test(
      'should save session state and tokens with rememberMe=true on successful login',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.login(any),
        ).thenAnswer((_) async => tLoginResponse);

        when(mockSessionService.setRememberMe(any)).thenAnswer((_) async {});

        when(mockSessionService.setGuestMode(any)).thenAnswer((_) async {});

        when(
          mockSessionService.saveTokens(
            token: anyNamed('token'),
            refreshToken: anyNamed('refreshToken'),
            rememberMe: anyNamed('rememberMe'),
          ),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.login(tLoginParams, true);

        // Assert
        expect(result, isA<SuccessResponse<LoginEntity>>());

        final loginData = (result as SuccessResponse<LoginEntity>).data;

        expect(loginData?.token, equals('jwt_token_123'));

        expect(loginData?.refreshToken, equals('refresh_token_123'));

        verify(mockDeviceIdService.getDeviceId()).called(1);

        verify(mockPushNotificationsServices.getFcmToken()).called(1);

        verify(mockSessionService.setRememberMe(true)).called(1);

        verify(mockSessionService.setGuestMode(false)).called(1);

        verify(
          mockSessionService.saveTokens(
            token: 'jwt_token_123',
            refreshToken: 'refresh_token_123',
            rememberMe: true,
          ),
        ).called(1);
      },
    );

    test(
      'should save session state and tokens with rememberMe=false on successful login',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.login(any),
        ).thenAnswer((_) async => tLoginResponse);

        when(mockSessionService.setRememberMe(any)).thenAnswer((_) async {});

        when(mockSessionService.setGuestMode(any)).thenAnswer((_) async {});

        when(
          mockSessionService.saveTokens(
            token: anyNamed('token'),
            refreshToken: anyNamed('refreshToken'),
            rememberMe: anyNamed('rememberMe'),
          ),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.login(tLoginParams, false);

        // Assert
        expect(result, isA<SuccessResponse<LoginEntity>>());

        verify(mockSessionService.setRememberMe(false)).called(1);

        verify(mockSessionService.setGuestMode(false)).called(1);

        verify(
          mockSessionService.saveTokens(
            token: 'jwt_token_123',
            refreshToken: 'refresh_token_123',
            rememberMe: false,
          ),
        ).called(1);
      },
    );

    test(
      'should return ErrorResponse and not call SessionService when login throws an exception',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.login(any),
        ).thenThrow(Exception('Invalid credentials'));

        // Act
        final result = await repository.login(tLoginParams, false);

        // Assert
        expect(result, isA<ErrorResponse<LoginEntity>>());

        verifyZeroInteractions(mockSessionService);
      },
    );

    test('should send deviceId and FCM token to remote data source', () async {
      // Arrange
      when(
        mockRemoteDataSource.login(any),
      ).thenAnswer((_) async => tLoginResponse);

      when(mockSessionService.setRememberMe(any)).thenAnswer((_) async {});

      when(mockSessionService.setGuestMode(any)).thenAnswer((_) async {});

      when(
        mockSessionService.saveTokens(
          token: anyNamed('token'),
          refreshToken: anyNamed('refreshToken'),
          rememberMe: anyNamed('rememberMe'),
        ),
      ).thenAnswer((_) async {});

      // Act
      await repository.login(tLoginParams, true);

      // Assert
      final captured = verify(
        mockRemoteDataSource.login(captureAny),
      ).captured.single;

      final request = captured as LoginRequest;

      expect(request.email, equals('ali@example.com'));

      expect(request.password, equals('Password123!'));

      expect(request.deviceId, equals('test-device-id'));

      expect(request.fcmToken, equals('test-fcm-token'));
    });
  });
}
