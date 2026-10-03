import 'package:flowrist/features/tracking_order/data/client/routing_api_client.dart';
import 'package:flowrist/features/tracking_order/domain/entities/routing_entity.dart';
import 'package:flowrist/features/tracking_order/domain/repositories/routing_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RoutingRepository)
class RoutingRepositoryImpl implements RoutingRepository {
  final RoutingApiClient _apiClient;

  RoutingRepositoryImpl(this._apiClient);

  @override
  Future<RoutingEntity> getRoute({required String coordinates}) async {
    final response = await _apiClient.getRoute(coordinates);

    return RoutingEntity(code: response.code, points: response.points);
  }
}
