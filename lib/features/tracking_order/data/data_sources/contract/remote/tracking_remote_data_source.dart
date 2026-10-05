import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/tracking_order/data/models/order_tracking_model.dart';

abstract interface class TrackingRemoteDataSource {
  Future<BaseResponse<OrderTrackingModel>> getOrderTracking(String orderId);
  Future<BaseResponse<void>> confirmDelivery(String orderId);
}
