import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/home/search_and_filtering/search/data/models/response/search_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'search_api_client.g.dart';

@singleton
@RestApi()
abstract class SearchApiClient {
  @factoryMethod
  factory SearchApiClient(Dio dio) = _SearchApiClient;

  @GET(Endpoints.searchProducts)
  Future<SearchResponseDto> searchProducts({
    @Query(AppConstants.searchParamQ) required String query,
    @Query(AppConstants.searchParamSort) String? sort,
    @Query(AppConstants.searchParamPage) int? page,
    @Query(AppConstants.searchParamPageSize) int? pageSize,
  });
}
