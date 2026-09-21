import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';

abstract class TrackingRepository {
  // Future<BaseResponse<OrderTrackingEntity>> getOrderTracking(String orderId);

  Stream<OrderTrackingEntity> watchOrderTracking(String orderId);
}
