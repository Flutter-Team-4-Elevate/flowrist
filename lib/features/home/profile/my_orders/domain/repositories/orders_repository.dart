import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_details_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/paginated_orders_entity.dart';

abstract class OrdersRepository {
  Future<BaseResponse<PaginatedOrdersEntity>> getOrders({
    int? page,
    int? pageSize,
  });

  Future<BaseResponse<OrderDetailsEntity>> getOrderDetails({
    required String orderId,
  });
}
