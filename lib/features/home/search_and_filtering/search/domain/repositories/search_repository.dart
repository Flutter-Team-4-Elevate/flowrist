import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';

abstract interface class SearchRepository {
  Future<BaseResponse<List<ProductEntity>>> searchProducts({
    required String query,
    String? sort,
    int? page,
    int? pageSize,
  });
}
