import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';
import 'package:flowrist/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowrist/features/auth/domain/use_cases/register_use_case.dart';

@GenerateMocks([AuthRepository])
import 'register_use_case_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late RegisterUseCase registerUseCase;

  const tUserEntity = UserEntity(
    id: '123',
    name: 'Ali Ibrahim',
    email: 'ali@example.com',
    phone: '01000000000',
  );

  setUp(() {
    provideDummy<BaseResponse<UserEntity>>(
      SuccessResponse<UserEntity>(tUserEntity),
    );

    mockAuthRepository = MockAuthRepository();
    registerUseCase = RegisterUseCase(mockAuthRepository);
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

  group('RegisterUseCase Unit Tests', () {
    test(
      'should get SuccessResponse<UserEntity> from repository on success',
      () async {
        // Arrange
        final tSuccessResponse = SuccessResponse<UserEntity>(tUserEntity);
        when(
          mockAuthRepository.register(any),
        ).thenAnswer((_) async => tSuccessResponse);

        // Act
        final result = await registerUseCase(tRequestDto);

        // Assert
        expect(result, isA<SuccessResponse<UserEntity>>());
        final successData = (result as SuccessResponse<UserEntity>).data;
        expect(successData?.id, equals('123'));
        expect(successData?.name, equals('Ali Ibrahim'));
        verify(mockAuthRepository.register(tRequestDto)).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return ErrorResponse when repository registration fails',
      () async {
        // Arrange
        final tErrorResponse = ErrorResponse<UserEntity>('Registration failed');
        when(
          mockAuthRepository.register(any),
        ).thenAnswer((_) async => tErrorResponse);

        // Act
        final result = await registerUseCase(tRequestDto);

        // Assert
        expect(result, isA<ErrorResponse<UserEntity>>());
        final errorResult = result as ErrorResponse<UserEntity>;
        expect(errorResult.errorMessage, equals('Registration failed'));
        verify(mockAuthRepository.register(tRequestDto)).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });
}
