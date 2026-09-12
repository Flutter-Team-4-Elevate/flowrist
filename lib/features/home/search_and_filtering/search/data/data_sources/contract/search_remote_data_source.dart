import 'package:flowrist/features/home/search_and_filtering/search/data/models/response/search_response_dto.dart';

abstract interface class SearchRemoteDataSource {
  Future<SearchResponseDto> searchProducts({
    required String query,
    String? sort,
    int? page,
    int? pageSize,
  });
}
