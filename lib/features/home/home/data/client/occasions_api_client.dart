import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/home/home/data/models/occasions/occasions_response_dto.dart';
import 'package:flowrist/features/home/home/data/models/occasions/products_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'occasions_api_client.g.dart';

@singleton
@RestApi()
abstract class OccasionsApiClient {
  @factoryMethod
  factory OccasionsApiClient(Dio dio) = _OccasionsApiClient;

  @GET(Endpoints.occasions)
  Future<OccasionsResponseDto> getOccasions();

  @GET(Endpoints.products)
  Future<ProductsResponseDto> getProducts({
    @Query(AppConstants.occasionId) String? occasionId,
    @Query(AppConstants.categoryId) String? categoryId,
  });
}
