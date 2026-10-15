import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flowrist/config/notifications/notification_constant.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocalNotificationService {
  LocalNotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  final StreamController<NotificationResponse> _notificationController =
      StreamController<NotificationResponse>.broadcast();

  Stream<NotificationResponse> get onNotificationTap =>
      _notificationController.stream;

  int _notificationId = 0;

  /// Fixed ID for the live order notification.
  ///
  /// Every order status update uses this same ID.
  /// Android therefore updates the existing notification
  /// instead of creating a new notification.
  static const int liveOrderNotificationId = 9001;

  // ============================================================
  // LIVE ORDER STATUSES
  // ============================================================

  /// The live notification starts from PICKED_UP.
  ///
  /// Before PICKED_UP:
  /// - PLACED
  /// - PREPARING
  ///
  /// These do NOT show the live ongoing notification.
  ///
  /// From PICKED_UP:
  /// - PICKED_UP
  /// - OUT_FOR_DELIVERY
  /// - ARRIVED
  /// - AWAITING_DELIVERY_CONFIRMATION
  ///
  /// The live notification is updated.
  ///
  /// DELIVERED:
  /// The live notification is removed.
  static const Set<String> liveOrderStatuses = {
    'PICKED_UP',
    'OUT_FOR_DELIVERY',
    'ARRIVED',
    'AWAITING_DELIVERY_CONFIRMATION',
  };

  // ============================================================
  // INITIALIZATION
  // ============================================================

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
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await _createAndroidChannels();

    log('🔔 LocalNotificationService initialized');
  }

  void _onNotificationTap(NotificationResponse response) {
    if (_notificationController.isClosed) {
      return;
    }

    _notificationController.add(response);
  }

  // ============================================================
  // CHANNELS
  // ============================================================

  Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) {
      return;
    }

    // ------------------------------------------------------------
    // NORMAL NOTIFICATION CHANNEL
    // ------------------------------------------------------------

    const normalChannel = AndroidNotificationChannel(
      NotificationConstants.channelId,
      NotificationConstants.channelName,
      description: NotificationConstants.channelDescription,
      importance: Importance.max,
      playSound: true,
    );

    // ------------------------------------------------------------
    // LIVE ORDER CHANNEL
    // ------------------------------------------------------------

    const liveOrderChannel = AndroidNotificationChannel(
      NotificationConstants.liveOrderChannelId,
      NotificationConstants.liveOrderChannelName,
      description: NotificationConstants.liveOrderChannelDescription,
      importance: Importance.high,
      playSound: false,
    );

    await androidPlugin.createNotificationChannel(normalChannel);

    await androidPlugin.createNotificationChannel(liveOrderChannel);

    log('🔔 Notification channels created');
  }

  // ============================================================
  // NORMAL NOTIFICATION
  // ============================================================

  Future<void> showBasicNotification(RemoteMessage message) async {
    final title =
        message.notification?.title ??
        message.data['title']?.toString() ??
        'Flowrist';

    final body =
        message.notification?.body ?? message.data['body']?.toString() ?? '';

    const androidDetails = AndroidNotificationDetails(
      NotificationConstants.channelId,
      NotificationConstants.channelName,
      channelDescription: NotificationConstants.channelDescription,

      importance: Importance.max,
      priority: Priority.high,

      playSound: true,
      enableVibration: true,

      color: Color(0xFFE91E63),

      /// Small status-bar icon.
      icon: NotificationConstants.androidIcon,

      /// App/logo icon.
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      id: _notificationId++,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: message.data.toString(),
    );

    log('🔔 Normal notification shown');
  }

  // ============================================================
  // ORDER TRACKING NOTIFICATION
  // ============================================================

  Future<void> showOrderTrackingNotification({
    required String orderNumber,
    required String status,
    String? bigPictureAsset,
  }) async {
    final normalizedStatus = status.toUpperCase().trim();

    log(
      '🚚 Tracking notification requested '
      'order=$orderNumber '
      'status=$normalizedStatus',
    );

    // ------------------------------------------------------------
    // DELIVERED
    // ------------------------------------------------------------

    if (normalizedStatus == 'DELIVERED') {
      await stopLiveOrderNotification();

      log('🎉 Order delivered - live notification removed');

      return;
    }

    // ------------------------------------------------------------
    // BEFORE PICKED_UP
    // ------------------------------------------------------------

    if (!liveOrderStatuses.contains(normalizedStatus)) {
      log(
        'ℹ️ Live notification ignored for status: '
        '$normalizedStatus',
      );

      return;
    }

    // ------------------------------------------------------------
    // PROGRESS
    // ------------------------------------------------------------

    final progress = _getProgressForStatus(normalizedStatus);

    // ------------------------------------------------------------
    // BIG PICTURE
    // ------------------------------------------------------------

    BigPictureStyleInformation? bigPictureStyleInformation;

    if (bigPictureAsset != null && bigPictureAsset.isNotEmpty) {
      bigPictureStyleInformation = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap(bigPictureAsset),
        hideExpandedLargeIcon: false,
        contentTitle: '🌸 Flowrist',
        summaryText: _getStatusText(normalizedStatus),
      );
    }

    // ------------------------------------------------------------
    // ANDROID DETAILS
    // ------------------------------------------------------------

    final androidDetails = AndroidNotificationDetails(
      NotificationConstants.liveOrderChannelId,
      NotificationConstants.liveOrderChannelName,

      channelDescription: NotificationConstants.liveOrderChannelDescription,

      color: const Color(0xFFE91E63),

      // Small notification icon.
      icon: NotificationConstants.androidIcon,

      // App/logo icon.
      largeIcon: const DrawableResourceAndroidBitmap('ic_launcher'),

      // Optional right-side/expanded image.
      styleInformation: bigPictureStyleInformation,

      importance: Importance.high,
      priority: Priority.high,

      // ----------------------------------------------------------
      // ONGOING NOTIFICATION
      // ----------------------------------------------------------

      /// User cannot normally swipe it away.
      ongoing: true,

      /// Do not automatically remove when tapped.
      autoCancel: false,

      /// Updating notification should not repeatedly alert user.
      onlyAlertOnce: true,

      playSound: false,
      enableVibration: false,

      // ----------------------------------------------------------
      // PROGRESS BAR
      // ----------------------------------------------------------
      showProgress: true,

      maxProgress: progress.total,

      progress: progress.completed,

      showWhen: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    // ------------------------------------------------------------
    // TITLE
    // ------------------------------------------------------------

    final title = '🌸 Flowrist • Order #$orderNumber';

    // ------------------------------------------------------------
    // BODY
    // ------------------------------------------------------------

    final body = _buildTrackingBody(normalizedStatus, progress);

    // ------------------------------------------------------------
    // SHOW / UPDATE
    // ------------------------------------------------------------

    await _plugin.show(
      id: liveOrderNotificationId,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: 'order:$orderNumber',
    );

    log(
      '✅ Live order notification shown/updated '
      'order=$orderNumber '
      'status=$normalizedStatus',
    );
  }

  // ============================================================
  // TRACKING BODY
  // ============================================================

  String _buildTrackingBody(String status, _OrderProgress progress) {
    final currentStatus = _getStatusText(status);

    final timeline = _buildTimeline(status);

    return '$currentStatus\n$timeline\n'
        'Progress: ${progress.completed}/${progress.total}';
  }

  // ============================================================
  // TIMELINE
  // ============================================================

  String _buildTimeline(String currentStatus) {
    const steps = [
      (status: 'PLACED', label: 'Order placed'),
      (status: 'PREPARING', label: 'Preparing'),
      (status: 'PICKED_UP', label: 'Picked up'),
      (status: 'OUT_FOR_DELIVERY', label: 'Out for delivery'),
      (status: 'ARRIVED', label: 'Arrived'),
      (status: 'AWAITING_DELIVERY_CONFIRMATION', label: 'Confirm delivery'),
      (status: 'DELIVERED', label: 'Delivered'),
    ];

    final currentIndex = steps.indexWhere(
      (step) => step.status == currentStatus,
    );

    // Unknown status.
    if (currentIndex == -1) {
      return steps.map((step) => '○ ${step.label}').join(' ─── ');
    }

    final buffer = StringBuffer();

    for (var i = 0; i < steps.length; i++) {
      final isCurrent = i == currentIndex;
      final isCompleted = i < currentIndex;

      // ----------------------------------------------------------
      // STEP ICON
      // ----------------------------------------------------------

      if (isCompleted) {
        buffer.write('✓ ${steps[i].label}');
      } else if (isCurrent) {
        buffer.write('● ${steps[i].label}');
      } else {
        buffer.write('○ ${steps[i].label}');
      }

      // ----------------------------------------------------------
      // CONNECTING LINE
      // ----------------------------------------------------------

      if (i < steps.length - 1) {
        if (i < currentIndex) {
          // Completed line.
          buffer.write(' ━━━ ');
        } else {
          // Remaining line.
          buffer.write(' ─── ');
        }
      }
    }

    return buffer.toString();
  }

  // ============================================================
  // STATUS TEXT
  // ============================================================

  String _getStatusText(String status) {
    switch (status) {
      case 'PLACED':
        return '📦 Your order has been placed';

      case 'PREPARING':
        return '👨‍🍳 Your order is being prepared';

      case 'PICKED_UP':
        return '📦 Your order has been picked up';

      case 'OUT_FOR_DELIVERY':
        return '🚚 Your order is out for delivery';

      case 'ARRIVED':
        return '📍 Your order has arrived';

      case 'AWAITING_DELIVERY_CONFIRMATION':
        return '✅ Please confirm your delivery';

      case 'DELIVERED':
        return '🎉 Your order has been delivered';

      default:
        return '📦 Your order status was updated';
    }
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  _OrderProgress _getProgressForStatus(String status) {
    switch (status) {
      case 'PICKED_UP':
        return const _OrderProgress(completed: 1, total: 4);

      case 'OUT_FOR_DELIVERY':
        return const _OrderProgress(completed: 2, total: 4);

      case 'ARRIVED':
        return const _OrderProgress(completed: 3, total: 4);

      case 'AWAITING_DELIVERY_CONFIRMATION':
        return const _OrderProgress(completed: 3, total: 4);

      case 'DELIVERED':
        return const _OrderProgress(completed: 4, total: 4);

      default:
        return const _OrderProgress(completed: 0, total: 4);
    }
  }

  // ============================================================
  // STOP LIVE ORDER NOTIFICATION
  // ============================================================

  Future<void> stopLiveOrderNotification() async {
    await _plugin.cancel(id: liveOrderNotificationId);

    log('🛑 ORDER TRACKING NOTIFICATION STOPPED');
  }

  // ============================================================
  // CONTROLS
  // ============================================================

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id: id);
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  Future<void> cancelLiveOrderNotification() async {
    await stopLiveOrderNotification();
  }

  // ============================================================
  // PERMISSION
  // ============================================================

  Future<bool> areNotificationsEnabled() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) {
      return true;
    }

    return await androidPlugin.areNotificationsEnabled() ?? true;
  }

  Future<bool> requestPermission() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) {
      return true;
    }

    final granted = await androidPlugin.requestNotificationsPermission();

    return granted ?? false;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  Future<void> dispose() async {
    await _notificationController.close();
  }
}

// ============================================================
// ORDER PROGRESS
// ============================================================

class _OrderProgress {
  const _OrderProgress({required this.completed, required this.total});

  final int completed;
  final int total;
}
