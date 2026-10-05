import 'package:dio/dio.dart';
import 'package:flowrist/features/tracking_order/data/models/routing_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'routing_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: 'https://router.project-osrm.org/')
abstract class RoutingApiClient {
  @factoryMethod
  factory RoutingApiClient(Dio dio) = _RoutingApiClient;

  @GET('route/v1/driving/{coordinates}')
  Future<RoutingResponseModel> getRoute(
    @Path('coordinates') String coordinates, {
    @Query('overview') String overview = 'full',
    @Query('geometries') String geometries = 'geojson',
  });
}
