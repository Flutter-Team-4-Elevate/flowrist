import 'package:flowrist/features/home/profile/my_orders/data/client/orders_api_client.dart';
import 'package:flowrist/features/home/profile/my_orders/data/data_sources/contract/orders_remote_data_source.dart';
import 'package:flowrist/features/home/profile/my_orders/data/models/response/order_details_response_dto.dart';
import 'package:flowrist/features/home/profile/my_orders/data/models/response/orders_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final OrdersApiClient _apiClient;

  OrdersRemoteDataSourceImpl(this._apiClient);

  @override
  Future<OrdersResponseDto> getOrders({int? page, int? pageSize}) async {
    return await _apiClient.getOrders(page: page, pageSize: pageSize);
  }

  @override
  Future<OrderDetailsResponseDto> getOrderDetails({
    required String orderId,
  }) async {
    return await _apiClient.getOrderDetails(orderId: orderId);
  }
}
