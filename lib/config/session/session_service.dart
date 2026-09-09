import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SessionService {
  final SecureStorageService _secureStorage;
  String? _inMemoryToken;
  String? _inMemoryRefreshToken;

  SessionService(this._secureStorage);

  Future<void> setRememberMe(bool value) async {
    await _secureStorage.save(AppConstants.rememberMeKey, value.toString());
  }

  Future<bool> isRemembered() async {
    final value = await _secureStorage.get(AppConstants.rememberMeKey);
    return value == 'true';
  }

  Future<void> setGuestMode(bool value) async {
    await _secureStorage.save(AppConstants.guestModeKey, value.toString());
  }

  Future<bool> isGuest() async {
    final value = await _secureStorage.get(AppConstants.guestModeKey);
    return value == 'true';
  }

  Future<void> saveTokens({
    required String token,
    required String refreshToken,
    bool rememberMe = true,
  }) async {
    _inMemoryToken = token;
    _inMemoryRefreshToken = refreshToken;

    if (rememberMe) {
      await _secureStorage.save(AppConstants.storageTokenKey, token);
      await _secureStorage.save(
        AppConstants.storageRefreshTokenKey,
        refreshToken,
      );
    } else {
      await _secureStorage.delete(AppConstants.storageTokenKey);
      await _secureStorage.delete(AppConstants.storageRefreshTokenKey);
    }
  }

  Future<void> updateTokens({
    required String token,
    required String refreshToken,
  }) async {
    _inMemoryToken = token;
    _inMemoryRefreshToken = refreshToken;

    final remembered = await isRemembered();
    if (remembered) {
      await _secureStorage.save(AppConstants.storageTokenKey, token);
      await _secureStorage.save(
        AppConstants.storageRefreshTokenKey,
        refreshToken,
      );
    }
  }

  Future<String> getToken() async {
    if (_inMemoryToken?.isNotEmpty == true) {
      return _inMemoryToken!;
    }
    final storedToken = await _secureStorage.get(AppConstants.storageTokenKey);
    if (storedToken.isNotEmpty) {
      _inMemoryToken = storedToken;
    }
    return storedToken;
  }

  Future<String> getRefreshToken() async {
    if (_inMemoryRefreshToken?.isNotEmpty == true) {
      return _inMemoryRefreshToken!;
    }
    final storedRefreshToken = await _secureStorage.get(
      AppConstants.storageRefreshTokenKey,
    );
    if (storedRefreshToken.isNotEmpty) {
      _inMemoryRefreshToken = storedRefreshToken;
    }
    return storedRefreshToken;
  }

  Future<void> clearSession() async {
    _inMemoryToken = null;
    _inMemoryRefreshToken = null;

    await _secureStorage.delete(AppConstants.storageTokenKey);
    await _secureStorage.delete(AppConstants.storageRefreshTokenKey);
    await _secureStorage.delete(AppConstants.rememberMeKey);
    await _secureStorage.delete(AppConstants.guestModeKey);
  }
}
