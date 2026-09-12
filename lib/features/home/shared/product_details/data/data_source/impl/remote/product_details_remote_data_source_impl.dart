import 'package:flowrist/features/home/shared/product_details/data/models/product_details_request_dto.dart';
import 'package:injectable/injectable.dart';

import 'package:flowrist/config/base_response/base_response.dart';

import '../../../client/product_details_api_client.dart';
import '../../contract/remote/product_details_remote_data_source.dart';

@Injectable(as: ProductDetailsRemoteDataSource)
class ProductRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  final ProductDetailsApiClient apiClient;

  ProductRemoteDataSourceImpl(this.apiClient);

  @override
  Future<BaseResponse<ProductDetailsRequestDto>> getProductDetails(
      String productId,
      ) async {
    try {
      final response = await apiClient.getProductDetails(productId);

      if (response.status && response.data != null) {
        return SuccessResponse(response.data);
      }

      return ErrorResponse(response.message);
    } catch (e) {
      return ErrorResponse(e.toString());
    }
  }
}