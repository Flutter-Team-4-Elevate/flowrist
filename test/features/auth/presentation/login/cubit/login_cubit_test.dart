import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/features/auth/domain/use_cases/login_use_case.dart';
import 'package:flowrist/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:flowrist/features/auth/presentation/login/cubit/login_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks([LoginUseCase, SessionService])
void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSessionService mockSessionService;
  late LoginCubit loginCubit;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSessionService = MockSessionService();

    loginCubit = LoginCubit(mockLoginUseCase, mockSessionService);
  });

  tearDown(() async {
    await loginCubit.close();
  });

  group('Remember Me', () {
    test('Test change rememberMe to true', () async {
      await loginCubit.doEvent(RememberMeChanged(true));

      expect(loginCubit.state.rememberMe, true);
    });

    test('Test change rememberMe to false', () async {
      await loginCubit.doEvent(RememberMeChanged(true));
      await loginCubit.doEvent(RememberMeChanged(false));

      expect(loginCubit.state.rememberMe, false);
    });
  });

  group('Form Validity', () {
    test('Test set form validity to true', () async {
      await loginCubit.doEvent(FormValidityChanged(true));

      expect(loginCubit.state.isFormValid, true);
    });

    test('should set form validity to false', () async {
      await loginCubit.doEvent(FormValidityChanged(true));
      await loginCubit.doEvent(FormValidityChanged(false));

      expect(loginCubit.state.isFormValid, false);
    });
  });
}
