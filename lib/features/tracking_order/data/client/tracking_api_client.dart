import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/tracking_order/data/models/order_tracking_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'tracking_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class TrackingApiClient {
  @factoryMethod
  factory TrackingApiClient(Dio dio) = _TrackingApiClient;

  @GET(Endpoints.orderTracking)
  Future<OrderTrackingResponseModel> getOrderTracking(
    @Path('orderId') String orderId,
  );
  @POST(Endpoints.confirmDelivery)
  Future<void> confirmDelivery(@Path('orderId') String orderId);
}
