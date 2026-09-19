import 'package:flowrist/features/home/categories/data/models/response/categories_response_dto.dart';

abstract interface class CategoriesRemoteDataSource {
  Future<CategoriesResponseDto> getCategories();
}
