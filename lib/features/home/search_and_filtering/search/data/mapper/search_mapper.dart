import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/search_and_filtering/search/data/models/response/search_response_dto.dart';

abstract final class SearchMapper {
  static List<ProductEntity> toProductEntityList(SearchResponseDto dto) {
    final items = dto.data ?? [];
    return items
        .where((item) => item.id != null && item.id!.isNotEmpty)
        .map(
          (item) => ProductEntity(
            id: item.id!,
            name: item.name ?? '',
            price: (item.price ?? 0).toDouble(),
            discountPercentage: item.discountPercentage?.toDouble(),
            discountPrice: item.discountPrice?.toDouble(),
            inStock: item.inStock ?? true,
            categoryId: item.categoryId ?? '',
            categoryName: item.categoryName ?? '',
            imageUrl: item.imageUrl ?? '',
          ),
        )
        .toList();
  }
}