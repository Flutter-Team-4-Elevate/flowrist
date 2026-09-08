import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';

abstract interface class CategoriesRepository {
  Future<BaseResponse<List<CategoryEntity>>> getCategories();
}
