 
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flowrist/config/device_id/device_id_services.dart';
import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/notifications/local_notificatoin_service.dart';
import 'package:flowrist/firebase_options.dart';
import 'package:flowrist/shared/notifications/domain/use_cases/update_fcmtoken_use_case.dart';

class PushNotificationsServices {
  static final FirebaseMessaging message =
      FirebaseMessaging.instance;

  static String? _fcmToken;

  /// Returns the current FCM token.
  static Future<String?> getFcmToken() async {
    try {
      // Return cached token if available.
      if (_fcmToken != null && _fcmToken!.isNotEmpty) {
        return _fcmToken;
      }

      // Get the current token from Firebase.
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

  /// Handles FCM token changes.
static void handleTokenRefresh() {
  message.onTokenRefresh.listen(
    (String newToken) async {
      try {
        _fcmToken = newToken;

        log('FCM TOKEN UPDATED: $newToken');

        final deviceId =
            await getIt<DeviceIdService>().getDeviceId();

        await getIt<UpdateFcmTokenUseCase>().call(
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

  /// Handles FCM messages when the app is in the background.
  @pragma('vm:entry-point')
  static Future<void> handleBackgroundMessage(
    RemoteMessage remoteMessage,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

  }

  /// Handles notifications while the app is open.
  static void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage remoteMessage) {

        LocalNotificationService.showBasicNotification(
          remoteMessage,
        );
      },
    );
  }

  /// Initializes Firebase Cloud Messaging.
  static Future<void> init() async {
    try {
      // final NotificationSettings settings =
      //     await message.requestPermission(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // );



      // Get the initial/current token.
      await getFcmToken();

      // Listen for future token updates.
      handleTokenRefresh();

      // Background messages.
      FirebaseMessaging.onBackgroundMessage(
        handleBackgroundMessage,
      );

      // Foreground messages.
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
 
