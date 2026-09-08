import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/paginated_orders_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/repositories/orders_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrdersUseCase {
  final OrdersRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<BaseResponse<PaginatedOrdersEntity>> call({
    required int page,
    required int pageSize,
  }) {
    return _repository.getOrders(page: page, pageSize: pageSize);
  }
}
