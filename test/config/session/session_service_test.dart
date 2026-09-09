import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

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
  const tRefreshToken = 'refresh_test_token_456';

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
      'saveTokens with rememberMe=true should update in-memory and write both tokens to storage',
      () async {
        when(
          mockSecureStorage.save(AppConstants.storageTokenKey, tToken),
        ).thenAnswer((_) async => {});
        when(
          mockSecureStorage.save(
            AppConstants.storageRefreshTokenKey,
            tRefreshToken,
          ),
        ).thenAnswer((_) async => {});

        await sessionService.saveTokens(
          token: tToken,
          refreshToken: tRefreshToken,
          rememberMe: true,
        );

        verify(
          mockSecureStorage.save(AppConstants.storageTokenKey, tToken),
        ).called(1);
        verify(
          mockSecureStorage.save(
            AppConstants.storageRefreshTokenKey,
            tRefreshToken,
          ),
        ).called(1);

        // In-memory verification: returns tokens without re-querying storage
        final token = await sessionService.getToken();
        final refreshToken = await sessionService.getRefreshToken();
        expect(token, equals(tToken));
        expect(refreshToken, equals(tRefreshToken));
        verifyNever(mockSecureStorage.get(AppConstants.storageTokenKey));
        verifyNever(mockSecureStorage.get(AppConstants.storageRefreshTokenKey));
      },
    );

    test(
      'saveTokens with rememberMe=false should update in-memory and delete both tokens from storage',
      () async {
        when(
          mockSecureStorage.delete(AppConstants.storageTokenKey),
        ).thenAnswer((_) async => {});
        when(
          mockSecureStorage.delete(AppConstants.storageRefreshTokenKey),
        ).thenAnswer((_) async => {});

        await sessionService.saveTokens(
          token: tToken,
          refreshToken: tRefreshToken,
          rememberMe: false,
        );

        verify(
          mockSecureStorage.delete(AppConstants.storageTokenKey),
        ).called(1);
        verify(
          mockSecureStorage.delete(AppConstants.storageRefreshTokenKey),
        ).called(1);

        // Tokens are still retained in-memory for the current active app session
        final token = await sessionService.getToken();
        final refreshToken = await sessionService.getRefreshToken();
        expect(token, equals(tToken));
        expect(refreshToken, equals(tRefreshToken));
        verifyNever(mockSecureStorage.get(AppConstants.storageTokenKey));
        verifyNever(mockSecureStorage.get(AppConstants.storageRefreshTokenKey));
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

    test(
      'getRefreshToken should fetch from storage and cache in-memory if memory is empty',
      () async {
        when(
          mockSecureStorage.get(AppConstants.storageRefreshTokenKey),
        ).thenAnswer((_) async => tRefreshToken);

        // First call fetches from storage
        final firstToken = await sessionService.getRefreshToken();
        expect(firstToken, equals(tRefreshToken));
        verify(
          mockSecureStorage.get(AppConstants.storageRefreshTokenKey),
        ).called(1);

        // Second call must fetch from in-memory cache directly
        final secondToken = await sessionService.getRefreshToken();
        expect(secondToken, equals(tRefreshToken));
        verifyNoMoreInteractions(mockSecureStorage);
      },
    );

    test(
      'updateTokens should update in-memory and write to storage if user is remembered',
      () async {
        when(
          mockSecureStorage.get(AppConstants.rememberMeKey),
        ).thenAnswer((_) async => 'true');
        when(
          mockSecureStorage.save(AppConstants.storageTokenKey, 'new_token'),
        ).thenAnswer((_) async => {});
        when(
          mockSecureStorage.save(
            AppConstants.storageRefreshTokenKey,
            'new_refresh_token',
          ),
        ).thenAnswer((_) async => {});

        await sessionService.updateTokens(
          token: 'new_token',
          refreshToken: 'new_refresh_token',
        );

        expect(await sessionService.getToken(), equals('new_token'));
        expect(
          await sessionService.getRefreshToken(),
          equals('new_refresh_token'),
        );
        verify(
          mockSecureStorage.save(AppConstants.storageTokenKey, 'new_token'),
        ).called(1);
        verify(
          mockSecureStorage.save(
            AppConstants.storageRefreshTokenKey,
            'new_refresh_token',
          ),
        ).called(1);
      },
    );
  });

  group('SessionService - Clear Session Tests', () {
    test(
      'clearSession should clear in-memory tokens and remove all storage keys',
      () async {
        when(mockSecureStorage.delete(any)).thenAnswer((_) async => {});
        when(
          mockSecureStorage.get(AppConstants.storageTokenKey),
        ).thenAnswer((_) async => '');

        // Set tokens first in-memory
        await sessionService.saveTokens(
          token: tToken,
          refreshToken: tRefreshToken,
          rememberMe: false,
        );

        // Clear session
        await sessionService.clearSession();

        verify(
          mockSecureStorage.delete(AppConstants.storageTokenKey),
        ).called(2); // 1 from saveTokens(false), 1 from clearSession
        verify(
          mockSecureStorage.delete(AppConstants.storageRefreshTokenKey),
        ).called(2); // 1 from saveTokens(false), 1 from clearSession
        verify(mockSecureStorage.delete(AppConstants.rememberMeKey)).called(1);
        verify(mockSecureStorage.delete(AppConstants.guestModeKey)).called(1);

        // Now getToken must re-read from storage because memory was cleared
        final tokenAfterClear = await sessionService.getToken();
        expect(tokenAfterClear, isEmpty);
        verify(mockSecureStorage.get(AppConstants.storageTokenKey)).called(1);
      },
    );
  });
}
