import 'package:flowrist/features/home/categories/data/models/response/categories_response_dto.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';

abstract final class CategoriesMapper {
  static List<CategoryEntity> toCategoryEntities(CategoriesResponseDto dto) {
    return dto.data?.map((item) {
          return CategoryEntity(
            id: item.id ?? '',
            name: item.name ?? '',
            iconUrl: item.iconUrl ?? '',
          );
        }).toList() ??
        [];
  }
}
