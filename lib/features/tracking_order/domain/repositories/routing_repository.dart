import 'package:flowrist/features/tracking_order/domain/entities/routing_entity.dart';

abstract class RoutingRepository {
  Future<RoutingEntity> getRoute({required String coordinates});
}
