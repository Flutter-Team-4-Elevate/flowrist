import 'package:flowrist/features/tracking_order/domain/entities/tracking_update_entity.dart';

abstract interface class TrackingNotificationDataSource {
  Stream<TrackingUpdateEntity> get trackingUpdates;
}
