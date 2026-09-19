import 'package:flowrist/features/home/search_and_filtering/search/data/client/search_api_client.dart';
import 'package:flowrist/features/home/search_and_filtering/search/data/data_sources/contract/search_remote_data_source.dart';
import 'package:flowrist/features/home/search_and_filtering/search/data/models/response/search_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchRemoteDataSource)
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final SearchApiClient _apiClient;

  SearchRemoteDataSourceImpl(this._apiClient);

  @override
  Future<SearchResponseDto> searchProducts({
    required String query,
    String? sort,
    int? page,
    int? pageSize,
  }) async {
    return await _apiClient.searchProducts(
      query: query,
      sort: sort,
      page: page,
      pageSize: pageSize,
    );
  }
}
