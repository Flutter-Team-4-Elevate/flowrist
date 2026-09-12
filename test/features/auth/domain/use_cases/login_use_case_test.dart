import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/domain/entities/login_entity.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';
import 'package:flowrist/features/auth/domain/params/login_params.dart';
import 'package:flowrist/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowrist/features/auth/domain/use_cases/login_use_case.dart';
import 'login_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  provideDummy<BaseResponse<LoginEntity>>(
    SuccessResponse(
      LoginEntity(
        user: UserEntity(id: '', email: '', phone: '', name: ''),
        token: '',
        refreshToken: '',
      ),
    ),
  );
  late MockAuthRepository mockAuthRepository;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  group('LoginUseCase', () {
    test(
      'Test call repository with correct params and return success response',
      () async {
        final params = LoginParams(
          email: 'test@test.com',
          password: '123456',
          fcmToken: '',
        );

        final loginEntity = LoginEntity(
          user: UserEntity(
            id: '1',
            email: 'test@test.com',
            phone: '01000000000',
            name: 'Test User',
          ),
          token: 'token123',
          refreshToken: 'refresh123',
        );

        final expectedResponse = SuccessResponse<LoginEntity>(loginEntity);

        when(
          mockAuthRepository.login(params, true),
        ).thenAnswer((_) async => expectedResponse);

        final result = await loginUseCase(params, true);

        expect(result, expectedResponse);

        verify(mockAuthRepository.login(params, true)).called(1);

        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'Test call repository with correct params and return error response',
      () async {
        final params = LoginParams(
          email: 'test@test.com',
          password: 'wrongPassword',
          fcmToken: '',
        );

        final expectedResponse = ErrorResponse<LoginEntity>(
          'Invalid email or password',
        );

        when(
          mockAuthRepository.login(params, false),
        ).thenAnswer((_) async => expectedResponse);

        final result = await loginUseCase(params, false);

        expect(result, expectedResponse);

        verify(mockAuthRepository.login(params, false)).called(1);

        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });
}
