import 'dart:ui';
import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/l10n/cubit/app_language_cubit.dart';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_language_cubit_test.mocks.dart';

@GenerateMocks([SecureStorageService])
void main() {
  late MockSecureStorageService mockStorage;
  const languageKey = 'app_language';

  setUp(() {
    mockStorage = MockSecureStorageService();
  });

  group('AppLanguageCubit', () {
    test(
      'initial state should be English when no language is stored',
      () async {
        when(mockStorage.get(languageKey)).thenAnswer((_) async => '');

        final cubit = AppLanguageCubit(mockStorage);

        expect(cubit.state, const Locale('en'));
      },
    );

    test(
      'initial state should emit saved language when valid language is stored',
      () async {
        when(mockStorage.get(languageKey)).thenAnswer((_) async => 'ar');

        final cubit = AppLanguageCubit(mockStorage);
        await pumpEventQueue();

        expect(cubit.state, const Locale('ar'));
      },
    );

    blocTest<AppLanguageCubit, Locale>(
      'emits [Locale("ar")] and saves to storage when changeLanguage is called with "ar"',
      build: () {
        when(mockStorage.get(languageKey)).thenAnswer((_) async => 'en');
        when(mockStorage.save(languageKey, 'ar')).thenAnswer((_) async => {});
        return AppLanguageCubit(mockStorage);
      },
      skip: 1,
      act: (cubit) => cubit.changeLanguage('ar'),
      expect: () => [const Locale('ar')],
      verify: (_) {
        verify(mockStorage.save(languageKey, 'ar')).called(1);
      },
    );

    blocTest<AppLanguageCubit, Locale>(
      'does not emit or save when changing to the already active language',
      build: () {
        when(mockStorage.get(languageKey)).thenAnswer((_) async => 'en');
        return AppLanguageCubit(mockStorage);
      },
      skip: 1,
      act: (cubit) => cubit.changeLanguage('en'),
      expect: () => [],
      verify: (_) {
        verifyNever(mockStorage.save(languageKey, 'en'));
      },
    );
  });
}
