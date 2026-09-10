import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flowrist/config/notifications/local_notificatoin_service.dart';
import 'package:flowrist/firebase_options.dart';

class PushNotificationsServices {
  static final FirebaseMessaging message =
      FirebaseMessaging.instance;

  static String? _fcmToken;

  /// Returns the current FCM token.
  static Future<String?> getFcmToken() async {
    if (_fcmToken != null && _fcmToken!.isNotEmpty) {
      return _fcmToken;
    }

    try {
      _fcmToken = await message.getToken();

      log(
        'FCM TOKEN: ${_fcmToken ?? "null"}',
      );

      return _fcmToken;
    } catch (error, stackTrace) {
      log(
        'Failed to get FCM token',
        error: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  /// Handles FCM messages when the app is in the background.
  @pragma('vm:entry-point')
  static Future<void> handleBackgroundMessage(
    RemoteMessage remoteMessage,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    log(
      'Background notification: '
      '${remoteMessage.notification?.title ?? "null"}',
    );

    log(
      'Background data: ${remoteMessage.data}',
    );
  }

  /// Handles notifications while the app is open.
  static void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage remoteMessage) {
        log(
          'Foreground notification: '
          '${remoteMessage.notification?.title ?? "null"}',
        );

        log(
          'Foreground data: ${remoteMessage.data}',
        );

        LocalNotificationService.showBasicNotification(
          remoteMessage,
        );
      },
    );
  }

  /// Initializes Firebase Cloud Messaging.
  static Future<void> init() async {
    try {
      final NotificationSettings settings =
          await message.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      log(
        'Notification permission: '
        '${settings.authorizationStatus}',
      );

      await getFcmToken();

      message.onTokenRefresh.listen(
        (String newToken) {
          _fcmToken = newToken;

          log(
            'NEW FCM TOKEN: $newToken',
          );

          // TODO:
          // If the user is already logged in,
          // update the token on the backend.
        },
      );

      FirebaseMessaging.onBackgroundMessage(
        handleBackgroundMessage,
      );

      handleForegroundMessage();
    } catch (error, stackTrace) {
      log(
        'Failed to initialize push notifications',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}