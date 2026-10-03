import 'package:flowrist/features/tracking_order/domain/entities/routing_entity.dart';
import 'package:flowrist/features/tracking_order/domain/repositories/routing_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetRouteUseCase {
  final RoutingRepository _repository;

  GetRouteUseCase(this._repository);

  Future<RoutingEntity> call({required String coordinates}) {
    return _repository.getRoute(coordinates: coordinates);
  }
}
