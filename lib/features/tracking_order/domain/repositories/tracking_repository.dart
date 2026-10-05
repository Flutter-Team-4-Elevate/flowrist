import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';

abstract interface class TrackingRepository {
  Stream<BaseResponse<OrderTrackingEntity>> watchOrderTracking(String orderId);
  Future<BaseResponse<void>> confirmDelivery(String orderId);
  Future<DateTime?> getEstimatedDeliveryAt();
}
