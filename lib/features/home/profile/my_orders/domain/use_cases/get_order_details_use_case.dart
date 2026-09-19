import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_details_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/repositories/orders_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrderDetailsUseCase {
  final OrdersRepository _repository;

  GetOrderDetailsUseCase(this._repository);

  Future<BaseResponse<OrderDetailsEntity>> call({
    required String orderId,
  }) async {
    return await _repository.getOrderDetails(orderId: orderId);
  }
}
