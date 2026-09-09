import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_details_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';

abstract interface class OrdersRepository {
  Future<BaseResponse<List<OrderEntity>>> getOrders({int? page, int? pageSize});

  Future<BaseResponse<OrderDetailsEntity>> getOrderDetails({
    required String orderId,
  });
}
