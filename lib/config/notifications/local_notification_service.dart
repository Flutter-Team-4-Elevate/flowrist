import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flowrist/config/notifications/notification_constant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  final StreamController<NotificationResponse> _notificationController =
      StreamController<NotificationResponse>.broadcast();

  int _notificationId = 0;

  LocalNotificationService(this._plugin);

  Stream<NotificationResponse> get onNotificationTap =>
      _notificationController.stream;

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      NotificationConstants.androidIcon,
    );

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onTap,
    );

    await _createAndroidChannel();
  }

  void _onTap(NotificationResponse response) {
    if (!_notificationController.isClosed) {
      _notificationController.add(response);
    }
  }

  Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      NotificationConstants.channelId,
      NotificationConstants.channelName,
      description: NotificationConstants.channelDescription,
      importance: Importance.max,
      playSound: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> showBasicNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      NotificationConstants.channelId,
      NotificationConstants.channelName,
      channelDescription: NotificationConstants.channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      id: _notificationId++,
      notificationDetails: notificationDetails,
      title: message.notification?.title ?? NotificationConstants.defaultTitle,
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  Future<void> dispose() async {
    await _notificationController.close();
  }
}
