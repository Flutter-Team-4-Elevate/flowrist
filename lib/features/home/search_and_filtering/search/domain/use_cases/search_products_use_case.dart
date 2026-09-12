import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/search_and_filtering/search/domain/repositories/search_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchProductsUseCase {
  final SearchRepository _repository;

  SearchProductsUseCase(this._repository);

  Future<BaseResponse<List<ProductEntity>>> call({
    required String query,
    String? sort,
    int? page,
    int? pageSize,
  }) async {
    return await _repository.searchProducts(
      query: query,
      sort: sort,
      page: page,
      pageSize: pageSize,
    );
  }
}
