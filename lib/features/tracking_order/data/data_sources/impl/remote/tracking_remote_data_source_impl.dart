import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/tracking_order/data/client/tracking_api_client.dart';
import 'package:flowrist/features/tracking_order/data/data_sources/contract/remote/tracking_remote_data_source.dart';
import 'package:flowrist/features/tracking_order/data/models/order_tracking_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TrackingRemoteDataSource)
class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final TrackingApiClient _apiClient;

  TrackingRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<OrderTrackingModel>> getOrderTracking(
    String orderId,
  ) async {
    try {
      final response = await _apiClient.getOrderTracking(orderId);

      if (!response.status) {
        return ErrorResponse(response.message);
      }

      return SuccessResponse(response.data);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException(e);
    }
  }

  @override
  Future<BaseResponse<dynamic>> confirmDelivery(String orderId) async {
    try {
     await _apiClient.confirmDelivery(orderId);

      return SuccessResponse(null);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException(e);
    }
  }
}
