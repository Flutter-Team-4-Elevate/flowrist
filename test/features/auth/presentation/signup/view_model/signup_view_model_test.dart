import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/domain/entities/user_entity.dart';
import 'package:flowrist/features/auth/domain/use_cases/register_use_case.dart';
import 'package:flowrist/features/auth/presentation/signup/view_model/signup_event.dart';
import 'package:flowrist/features/auth/presentation/signup/view_model/signup_state.dart';
import 'package:flowrist/features/auth/presentation/signup/view_model/signup_view_model.dart';

@GenerateMocks([RegisterUseCase])
import 'signup_view_model_test.mocks.dart';

void main() {
  late MockRegisterUseCase mockRegisterUseCase;
  late SignUpViewModel viewModel;

  const tUserEntity = UserEntity(
    id: '123',
    name: 'Ali Ibrahim',
    email: 'ali@example.com',
    phone: '01000000000',
  );

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

  setUp(() {
    provideDummy<BaseResponse<UserEntity>>(
      SuccessResponse<UserEntity>(tUserEntity),
    );

    mockRegisterUseCase = MockRegisterUseCase();
    viewModel = SignUpViewModel(mockRegisterUseCase);
  });

  tearDown(() {
    viewModel.close();
  });

  group('SignUpViewModel Unit Tests', () {
    test(
      'initial state should have isLoading: false, errorMessage: null, data: null',
      () {
        expect(
          viewModel.state,
          isA<SignUpState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', isNull)
              .having((s) => s.data, 'data', isNull),
        );
      },
    );

    blocTest<SignUpViewModel, SignUpState>(
      'should emit [isLoading: true, SuccessResponse data] when SignUpSubmittedEvent succeeds',
      build: () {
        when(
          mockRegisterUseCase(any),
        ).thenAnswer((_) async => SuccessResponse<UserEntity>(tUserEntity));
        return viewModel;
      },
      act: (cubit) => cubit.doIntent(SignUpSubmittedEvent(tRequestDto)),
      expect: () => [
        isA<SignUpState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.errorMessage, 'errorMessage', isNull),
        isA<SignUpState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.data?.id, 'data.id', '123'),
      ],
      verify: (_) {
        verify(mockRegisterUseCase(tRequestDto)).called(1);
      },
    );

    blocTest<SignUpViewModel, SignUpState>(
      'should emit [isLoading: true, errorMessage] when SignUpSubmittedEvent fails',
      build: () {
        when(mockRegisterUseCase(any)).thenAnswer(
          (_) async => ErrorResponse<UserEntity>('Registration failed'),
        );
        return viewModel;
      },
      act: (cubit) => cubit.doIntent(SignUpSubmittedEvent(tRequestDto)),
      expect: () => [
        isA<SignUpState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.errorMessage, 'errorMessage', isNull),
        isA<SignUpState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Registration failed',
            ),
      ],
      verify: (_) {
        verify(mockRegisterUseCase(tRequestDto)).called(1);
      },
    );
  });
}
