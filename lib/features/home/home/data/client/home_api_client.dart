import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/home/home/data/models/home_model/home_api_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'home_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class HomeApiClient {
  @factoryMethod
  factory HomeApiClient(Dio dio) = _HomeApiClient;

  @GET(Endpoints.home)
  Future<HomeApiResponseModel> getHomeLayout();

 
}
