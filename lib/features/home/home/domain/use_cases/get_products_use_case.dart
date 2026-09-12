import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/home/domain/repositories/occasions_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsUseCase {
  final OccasionsRepository _repository;

  GetProductsUseCase(this._repository);

  Future<BaseResponse<List<ProductEntity>>> call({
    String? occasionId,
    String? categoryId,
    String? sort,
  }) async {
    return await _repository.getProducts(
      occasionId: occasionId,
      categoryId: categoryId,
      sort: sort,
    );
  }
}
