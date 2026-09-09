import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/repositories/orders_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrdersUseCase {
  final OrdersRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<BaseResponse<List<OrderEntity>>> call({
    int? page,
    int? pageSize,
  }) async {
    return await _repository.getOrders(page: page, pageSize: pageSize);
  }
}
