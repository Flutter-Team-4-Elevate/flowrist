import 'package:flowrist/features/home/home/data/client/occasions_api_client.dart';
import 'package:flowrist/features/home/home/data/data_sources/contract/remote/occasions_remote_data_source.dart';
import 'package:flowrist/features/home/home/data/models/occasions/occasions_response_dto.dart';
import 'package:flowrist/features/home/home/data/models/occasions/products_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OccasionsRemoteDataSource)
class OccasionsRemoteDataSourceImpl implements OccasionsRemoteDataSource {
  final OccasionsApiClient _apiClient;

  OccasionsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<OccasionsResponseDto> getOccasions() async {
    return await _apiClient.getOccasions();
  }

  @override
  Future<ProductsResponseDto> getProducts({
    String? occasionId,
    String? categoryId,
  }) async {
    // // Simulate network delay for testing purposes
    // await Future.delayed(const Duration(milliseconds: 500));

    // if (occasionId != null) {
    //   return ProductsResponseDto.fromJson(MockProductsResponse.occasionProductsJson);
    // }

    // return ProductsResponseDto.fromJson(MockProductsResponse.categoryProductsJson);

    // the following code is commented out because the API endpoint is not yet implemented
    return await _apiClient.getProducts(
      occasionId: occasionId,
      categoryId: categoryId,
    );
  }
}
