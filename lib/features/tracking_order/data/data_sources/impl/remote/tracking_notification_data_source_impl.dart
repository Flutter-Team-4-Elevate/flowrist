import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flowrist/config/notifications/notification_service.dart';
import 'package:flowrist/features/tracking_order/data/data_sources/contract/remote/tracking_notification_data_source.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_update_entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TrackingNotificationDataSource)
class TrackingNotificationDataSourceImpl
    implements TrackingNotificationDataSource {
  final PushNotificationsServices _notificationsService;

  TrackingNotificationDataSourceImpl(this._notificationsService);

  @override
  Stream<TrackingUpdateEntity> get trackingUpdates {
    return _notificationsService.messages
        .where(_isTrackingNotification)
        .map(_mapToTrackingUpdate);
  }

  bool _isTrackingNotification(RemoteMessage message) {
    return message.data['type'] == 'ORDER_TRACKING_UPDATED';
  }

  TrackingUpdateEntity _mapToTrackingUpdate(RemoteMessage message) {
    return TrackingUpdateEntity(
      orderId: message.data['orderId'] as String,
      status: message.data['status'] as String?,
    );
  }
}
