import 'package:flowrist/features/home/profile/my_orders/data/models/response/order_details_response_dto.dart';
import 'package:flowrist/features/home/profile/my_orders/data/models/response/orders_response_dto.dart';

abstract interface class OrdersRemoteDataSource {
  Future<OrdersResponseDto> getOrders({int? page, int? pageSize});
  Future<OrderDetailsResponseDto> getOrderDetails({required String orderId});
}
