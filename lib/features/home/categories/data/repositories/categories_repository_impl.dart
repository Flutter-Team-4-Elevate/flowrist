import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/categories/data/data_sources/contract/remote/categories_remote_data_source.dart';
import 'package:flowrist/features/home/categories/data/mapper/categories_mapper.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';
import 'package:flowrist/features/home/categories/domain/repositories/categories_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoriesRepository)
class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource _remoteDataSource;

  CategoriesRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<CategoryEntity>>> getCategories() async {
    try {
      final responseDto = await _remoteDataSource.getCategories();
      final entities = CategoriesMapper.toCategoryEntities(responseDto);
      return SuccessResponse<List<CategoryEntity>>(entities);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<List<CategoryEntity>>(e);
    }
  }
}
