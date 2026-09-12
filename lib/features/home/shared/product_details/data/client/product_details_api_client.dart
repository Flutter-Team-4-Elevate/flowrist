import 'package:dio/dio.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/product_details_response_dto.dart';

part 'product_details_api_client.g.dart';

@singleton
@RestApi()
abstract class ProductDetailsApiClient {
  @factoryMethod
  factory ProductDetailsApiClient(Dio dio) = _ProductDetailsApiClient;

  @GET('${Endpoints.productDetails}/{id}')
  Future<ProductDetailsResponseDto> getProductDetails(
      @Path('id') String productId,
      );
}