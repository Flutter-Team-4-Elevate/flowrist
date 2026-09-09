import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/my_orders/data/data_sources/contract/orders_remote_data_source.dart';
import 'package:flowrist/features/home/profile/my_orders/data/mapper/orders_mapper.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_details_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/repositories/orders_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrdersRepository)
class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remoteDataSource;

  OrdersRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<OrderEntity>>> getOrders({
    int? page,
    int? pageSize,
  }) async {
    try {
      final responseDto = await _remoteDataSource.getOrders(
        page: page,
        pageSize: pageSize,
      );
      final entities = OrdersMapper.toOrderEntityList(responseDto);
      return SuccessResponse<List<OrderEntity>>(entities);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<List<OrderEntity>>(e);
    }
  }

  @override
  Future<BaseResponse<OrderDetailsEntity>> getOrderDetails({
    required String orderId,
  }) async {
    try {
      final responseDto = await _remoteDataSource.getOrderDetails(
        orderId: orderId,
      );
      final entity = OrdersMapper.toOrderDetailsEntity(responseDto);
      return SuccessResponse<OrderDetailsEntity>(entity);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<OrderDetailsEntity>(e);
    }
  }
}
