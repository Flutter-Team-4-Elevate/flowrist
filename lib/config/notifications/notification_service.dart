import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  bool _disposed = false;

  final StreamController<RemoteMessage> _messageController =
      StreamController<RemoteMessage>.broadcast();

  PushNotificationsServices(
    this._messaging,
    this._deviceIdService,
    this._updateFcmTokenUseCase,
    this._localNotificationService,
  );

  Stream<RemoteMessage> get messages => _messageController.stream;

  Future<String?> getFcmToken() async {
    if (_disposed) return null;

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
    if (_initialized || _disposed) {
      return;
    }

    _initialized = true;

    try {
      await _localNotificationService.init();

      await getFcmToken();

      _listenToTokenRefresh();
      _listenToForegroundMessages();

      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      await requestPermission();
    } catch (error, stackTrace) {
      log(
        'Failed to initialize push notifications',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<bool> requestPermission() async {
    if (_disposed) return false;

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
    if (_disposed) return;

    final token = await getFcmToken();

    if (token == null || token.isEmpty || _disposed) {
      return;
    }

    final deviceId = await _deviceIdService.getDeviceId();

    if (_disposed) return;

    await _updateFcmTokenUseCase.call(deviceId: deviceId, fcmToken: token);
  }

  void _listenToTokenRefresh() {
    if (_disposed) return;

    _tokenRefreshSubscription ??= _messaging.onTokenRefresh.listen(
      (newToken) async {
        if (_disposed) return;

        try {
          _fcmToken = newToken;

          log('FCM TOKEN UPDATED: $newToken');

          final deviceId = await _deviceIdService.getDeviceId();

          if (_disposed) return;

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
    if (_disposed) return;

    _foregroundSubscription ??= FirebaseMessaging.onMessage.listen(
      (remoteMessage) {
        if (_disposed) return;

        log(
          'Foreground FCM received: '
          '${remoteMessage.messageId}',
        );

        if (!_messageController.isClosed) {
          _messageController.add(remoteMessage);
        }
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
    if (_disposed) return;

    _disposed = true;

    await _tokenRefreshSubscription?.cancel();
    await _foregroundSubscription?.cancel();

    _tokenRefreshSubscription = null;
    _foregroundSubscription = null;

    await _messageController.close();
  }
}
