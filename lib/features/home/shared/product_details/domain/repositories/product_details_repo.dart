import 'package:flowrist/config/base_response/base_response.dart';

import '../../data/models/product_details_request_dto.dart';

abstract interface class ProductRepository {
  Future<BaseResponse<ProductDetailsRequestDto>> getProductDetails(
      String productId,
      );
}