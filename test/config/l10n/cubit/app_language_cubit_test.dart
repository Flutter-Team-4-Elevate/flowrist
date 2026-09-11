import 'dart:ui';
import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/l10n/cubit/app_language_cubit.dart';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/core/constants/app_language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_language_cubit_test.mocks.dart';

@GenerateMocks([SecureStorageService])
void main() {
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockStorage = MockSecureStorageService();
  });

  group('AppLanguageCubit', () {
    test(
      'initial state should be English when no language is stored',
      () async {
        when(
          mockStorage.get(AppConstants.languageKey),
        ).thenAnswer((_) async => '');

        final cubit = AppLanguageCubit(mockStorage);

        expect(cubit.state, AppLanguage.english.locale);
      },
    );

    test(
      'initial state should emit saved language when valid language is stored',
      () async {
        when(
          mockStorage.get(AppConstants.languageKey),
        ).thenAnswer((_) async => AppLanguage.arabic.code);

        final cubit = AppLanguageCubit(mockStorage);
        await pumpEventQueue();

        expect(cubit.state, AppLanguage.arabic.locale);
      },
    );

    blocTest<AppLanguageCubit, Locale>(
      'emits [Locale("ar")] and saves to storage when changeLanguage is called with AppLanguage.arabic',
      build: () {
        when(
          mockStorage.get(AppConstants.languageKey),
        ).thenAnswer((_) async => AppLanguage.english.code);
        when(
          mockStorage.save(AppConstants.languageKey, AppLanguage.arabic.code),
        ).thenAnswer((_) async => {});
        return AppLanguageCubit(mockStorage);
      },
      skip: 1, // 👈 يتجاهل emit(Locale('en')) القادمة من _loadSavedLanguage
      act: (cubit) => cubit.changeLanguage(AppLanguage.arabic),
      expect: () => [AppLanguage.arabic.locale],
      verify: (_) {
        verify(
          mockStorage.save(AppConstants.languageKey, AppLanguage.arabic.code),
        ).called(1);
      },
    );

    blocTest<AppLanguageCubit, Locale>(
      'does not emit or save when changing to the already active language',
      build: () {
        when(
          mockStorage.get(AppConstants.languageKey),
        ).thenAnswer((_) async => AppLanguage.english.code);
        return AppLanguageCubit(mockStorage);
      },
      skip: 1, // 👈 يتجاهل emit(Locale('en')) القادمة من _loadSavedLanguage
      act: (cubit) => cubit.changeLanguage(AppLanguage.english),
      expect: () => [],
      verify: (_) {
        verifyNever(
          mockStorage.save(AppConstants.languageKey, AppLanguage.english.code),
        );
      },
    );
  });
}
