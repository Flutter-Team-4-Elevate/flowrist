import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flowrist/config/device_id/device_id_services.dart';
import 'package:flowrist/config/notifications/local_notification_service.dart';
import 'package:flowrist/firebase_options.dart';
import 'package:flowrist/shared/notifications/domain/use_cases/update_fcmtoken_use_case.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PushNotificationsServices {
  final FirebaseMessaging _messaging;
  final DeviceIdService _deviceIdService;
  final UpdateFcmTokenUseCase _updateFcmTokenUseCase;
  final LocalNotificationService _localNotificationService;

  String? _fcmToken;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;

  bool _initialized = false;
  bool _permissionRequestedThisSession = false;

  PushNotificationsServices(
    this._messaging,
    this._deviceIdService,
    this._updateFcmTokenUseCase,
    this._localNotificationService,
  );

  Future<String?> getFcmToken() async {
    try {
      if (_fcmToken != null && _fcmToken!.isNotEmpty) {
        return _fcmToken;
      }

      _fcmToken = await _messaging.getToken();

      log('FCM TOKEN: ${_fcmToken ?? "null"}');

      return _fcmToken;
    } catch (error, stackTrace) {
      log('Failed to get FCM token', error: error, stackTrace: stackTrace);

      return null;
    }
  }

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    _initialized = true;

    try {
      await _localNotificationService.init();

      await getFcmToken();

      _listenToTokenRefresh();
      _listenToForegroundMessages();

      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      // Request notification permission when the app starts.
      await requestPermission();
    } catch (error, stackTrace) {
      log(
        'Failed to initialize push notifications',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Requests OS notification permission.
  ///
  /// This should NOT be called automatically from [init].
  /// Call it from Home once per app session or when the user
  /// explicitly enables notifications from Profile.
  Future<bool> requestPermission() async {
    if (_permissionRequestedThisSession) {
      return true;
    }

    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      _permissionRequestedThisSession = true;

      final isAuthorized =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      if (isAuthorized) {
        await _syncCurrentToken();
      }

      return isAuthorized;
    } catch (error, stackTrace) {
      log(
        'Failed to request notification permission',
        error: error,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  Future<void> _syncCurrentToken() async {
    final token = await getFcmToken();

    if (token == null || token.isEmpty) {
      return;
    }

    final deviceId = await _deviceIdService.getDeviceId();

    await _updateFcmTokenUseCase.call(deviceId: deviceId, fcmToken: token);
  }

  void _listenToTokenRefresh() {
    _tokenRefreshSubscription ??= _messaging.onTokenRefresh.listen(
      (newToken) async {
        try {
          _fcmToken = newToken;

          log('FCM TOKEN UPDATED: $newToken');

          final deviceId = await _deviceIdService.getDeviceId();

          await _updateFcmTokenUseCase.call(
            deviceId: deviceId,
            fcmToken: newToken,
          );
        } catch (error, stackTrace) {
          log(
            'Failed to update FCM token on server',
            error: error,
            stackTrace: stackTrace,
          );
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        log(
          'FCM token refresh listener error',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  void _listenToForegroundMessages() {
    _foregroundSubscription ??= FirebaseMessaging.onMessage.listen(
      (remoteMessage) async {
        await _localNotificationService.showBasicNotification(remoteMessage);
      },
      onError: (Object error, StackTrace stackTrace) {
        log(
          'Foreground notification listener error',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @pragma('vm:entry-point')
  static Future<void> handleBackgroundMessage(
    RemoteMessage remoteMessage,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _foregroundSubscription?.cancel();

    _tokenRefreshSubscription = null;
    _foregroundSubscription = null;
  }
}
