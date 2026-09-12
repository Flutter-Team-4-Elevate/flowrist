import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/shared/product_details/data/models/product_details_request_dto.dart';


abstract interface class ProductDetailsRemoteDataSource {
  Future<BaseResponse<ProductDetailsRequestDto>> getProductDetails(
      String productId,
      );
}