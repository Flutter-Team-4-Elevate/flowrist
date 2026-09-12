import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/home/categories/data/models/response/categories_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'categories_api_client.g.dart';

@singleton
@RestApi()
abstract class CategoriesApiClient {
  @factoryMethod
  factory CategoriesApiClient(Dio dio) = _CategoriesApiClient;

  @GET(Endpoints.categories)
  Future<CategoriesResponseDto> getCategories();
}
