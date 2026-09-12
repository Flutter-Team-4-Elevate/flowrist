import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/app_constants.dart';

@GenerateMocks([SecureStorageService])
import 'session_service_test.mocks.dart';

void main() {
  late MockSecureStorageService mockSecureStorage;
  late SessionService sessionService;

  setUp(() {
    mockSecureStorage = MockSecureStorageService();
    sessionService = SessionService(mockSecureStorage);
  });

  const tToken = 'jwt_test_token_123';

  group('SessionService - RememberMe Tests', () {
    test('setRememberMe should save boolean string into storage', () async {
      when(
        mockSecureStorage.save(AppConstants.rememberMeKey, 'true'),
      ).thenAnswer((_) async => {});

      await sessionService.setRememberMe(true);

      verify(
        mockSecureStorage.save(AppConstants.rememberMeKey, 'true'),
      ).called(1);
    });

    test('isRemembered should return true when storage has "true"', () async {
      when(
        mockSecureStorage.get(AppConstants.rememberMeKey),
      ).thenAnswer((_) async => 'true');

      final result = await sessionService.isRemembered();

      expect(result, isTrue);
      verify(mockSecureStorage.get(AppConstants.rememberMeKey)).called(1);
    });

    test(
      'isRemembered should return false when storage does not have "true"',
      () async {
        when(
          mockSecureStorage.get(AppConstants.rememberMeKey),
        ).thenAnswer((_) async => 'false');

        final result = await sessionService.isRemembered();

        expect(result, isFalse);
      },
    );
  });

  group('SessionService - GuestMode Tests', () {
    test('setGuestMode should save string boolean into storage', () async {
      when(
        mockSecureStorage.save(AppConstants.guestModeKey, 'true'),
      ).thenAnswer((_) async => {});

      await sessionService.setGuestMode(true);

      verify(
        mockSecureStorage.save(AppConstants.guestModeKey, 'true'),
      ).called(1);
    });

    test('isGuest should return true when storage has "true"', () async {
      when(
        mockSecureStorage.get(AppConstants.guestModeKey),
      ).thenAnswer((_) async => 'true');

      final result = await sessionService.isGuest();

      expect(result, isTrue);
    });
  });

  group('SessionService - Token Management & In-Memory Logic Tests', () {
    test(
      'saveToken with rememberMe=true should update in-memory and write to storage',
      () async {
        when(
          mockSecureStorage.save(AppConstants.storageTokenKey, tToken),
        ).thenAnswer((_) async => {});

        await sessionService.saveToken(tToken, rememberMe: true);

        verify(
          mockSecureStorage.save(AppConstants.storageTokenKey, tToken),
        ).called(1);

        // Verify that getToken returns token from memory without calling storage.get
        final token = await sessionService.getToken();
        expect(token, equals(tToken));
        verifyNever(mockSecureStorage.get(AppConstants.storageTokenKey));
      },
    );

    test(
      'saveToken with rememberMe=false should update in-memory and delete from storage',
      () async {
        when(
          mockSecureStorage.delete(AppConstants.storageTokenKey),
        ).thenAnswer((_) async => {});

        await sessionService.saveToken(tToken, rememberMe: false);

        verify(
          mockSecureStorage.delete(AppConstants.storageTokenKey),
        ).called(1);

        // In-memory token still exists and works for current session
        final token = await sessionService.getToken();
        expect(token, equals(tToken));
        verifyNever(mockSecureStorage.get(AppConstants.storageTokenKey));
      },
    );

    test(
      'getToken should fetch from storage and cache in-memory if memory is empty',
      () async {
        when(
          mockSecureStorage.get(AppConstants.storageTokenKey),
        ).thenAnswer((_) async => tToken);

        // First call fetches from storage
        final firstToken = await sessionService.getToken();
        expect(firstToken, equals(tToken));
        verify(mockSecureStorage.get(AppConstants.storageTokenKey)).called(1);

        // Second call must fetch from in-memory cache directly
        final secondToken = await sessionService.getToken();
        expect(secondToken, equals(tToken));
        verifyNoMoreInteractions(mockSecureStorage);
      },
    );
  });

  group('SessionService - Clear Session Tests', () {
    test(
      'clearSession should clear in-memory token and remove all storage keys',
      () async {
        when(mockSecureStorage.delete(any)).thenAnswer((_) async => {});
        when(
          mockSecureStorage.get(AppConstants.storageTokenKey),
        ).thenAnswer((_) async => '');

        // Set token first in-memory
        await sessionService.saveToken(tToken, rememberMe: false);

        // Clear session
        await sessionService.clearSession();

        verify(
          mockSecureStorage.delete(AppConstants.storageTokenKey),
        ).called(2); // 1 from saveToken(false), 1 from clearSession
        verify(mockSecureStorage.delete(AppConstants.rememberMeKey)).called(1);
        verify(mockSecureStorage.delete(AppConstants.guestModeKey)).called(1);

        // Now getToken must re-read empty string from storage because memory is cleared
        final tokenAfterClear = await sessionService.getToken();
        expect(tokenAfterClear, isEmpty);
        verify(mockSecureStorage.get(AppConstants.storageTokenKey)).called(1);
      },
    );
  });
}
