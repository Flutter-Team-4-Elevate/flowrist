import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/home/profile/my_orders/data/models/response/order_details_response_dto.dart';
import 'package:flowrist/features/home/profile/my_orders/data/models/response/orders_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'orders_api_client.g.dart';

@singleton
@RestApi()
abstract class OrdersApiClient {
  @factoryMethod
  factory OrdersApiClient(Dio dio) = _OrdersApiClient;

  @GET(Endpoints.orders)
  Future<OrdersResponseDto> getOrders({
    @Query(AppConstants.searchParamPage) int? page,
    @Query(AppConstants.searchParamPageSize) int? pageSize,
  });

  @GET('${Endpoints.orders}/{orderId}')
  Future<OrderDetailsResponseDto> getOrderDetails({
    @Path('orderId') required String orderId,
  });
}
