import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final StreamController<NotificationResponse> streamController =
      StreamController<NotificationResponse>.broadcast();

  static int _notificationId = 0;

  static void onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      onDidReceiveNotificationResponse: onTap,
      settings: settings,
    );

    await _createAndroidChannel();
  }

  static Future<void> _createAndroidChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'flowrist_notifications',
      'Flowrist Notifications',
      description: 'Flowrist app notifications',
      importance: Importance.max,
      playSound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<void> showBasicNotification(RemoteMessage message) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'flowrist_notifications',
      'Flowrist Notifications',
      channelDescription: 'Flowrist app notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details = NotificationDetails(android: android);

    await flutterLocalNotificationsPlugin.show(
      id: _notificationId++,
      notificationDetails: details,
      title: message.notification?.title ?? 'Flowrist',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }
}
