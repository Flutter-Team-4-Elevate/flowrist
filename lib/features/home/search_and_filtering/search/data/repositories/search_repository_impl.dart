import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/search_and_filtering/search/data/data_sources/contract/search_remote_data_source.dart';
import 'package:flowrist/features/home/search_and_filtering/search/data/mapper/search_mapper.dart';
import 'package:flowrist/features/home/search_and_filtering/search/domain/repositories/search_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<ProductEntity>>> searchProducts({
    required String query,
    String? sort,
    int? page,
    int? pageSize,
  }) async {
    try {
      final responseDto = await _remoteDataSource.searchProducts(
        query: query,
        sort: sort,
        page: page,
        pageSize: pageSize,
      );
      final entities = SearchMapper.toProductEntityList(responseDto);
      return SuccessResponse<List<ProductEntity>>(entities);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<List<ProductEntity>>(e);
    }
  }
}
