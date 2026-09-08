import 'package:injectable/injectable.dart';

import 'package:flowrist/config/base_response/base_response.dart';

import '../../data/models/product_details_request_dto.dart';
import '../repositories/product_details_repo.dart';

@injectable
class GetProductDetailsUseCase {
  final ProductRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<BaseResponse<ProductDetailsRequestDto>> call(String productId) {
    return repository.getProductDetails(productId);
  }
}
