import 'package:flowrist/features/home/categories/data/client/categories_api_client.dart';
import 'package:flowrist/features/home/categories/data/data_sources/contract/remote/categories_remote_data_source.dart';
import 'package:flowrist/features/home/categories/data/models/response/categories_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoriesRemoteDataSource)
class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final CategoriesApiClient _apiClient;

  CategoriesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<CategoriesResponseDto> getCategories() async {
    return await _apiClient.getCategories();
  }
}
