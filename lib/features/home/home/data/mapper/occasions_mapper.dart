import 'package:flowrist/features/home/home/data/models/occasions/occasions_response_dto.dart';
import 'package:flowrist/features/home/home/data/models/occasions/products_response_dto.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/occasion_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';

abstract final class OccasionsMapper {
  static List<OccasionEntity> toOccasionEntities(OccasionsResponseDto dto) {
    return dto.data?.map((item) {
          return OccasionEntity(
            id: item.id ?? '',
            name: item.name ?? '',
            imageUrl: item.imageUrl ?? '',
          );
        }).toList() ??
        [];
  }

  static List<ProductEntity> toProductEntities(ProductsResponseDto dto) {
    return dto.data?.map((item) {
          return ProductEntity(
            id: item.id ?? '',
            name: item.name ?? '',
            price: item.price ?? 0.0,
            discountPercentage: item.discountPercentage,
            discountPrice: item.discountPrice,
            inStock: item.inStock ?? false,
            categoryId: item.categoryId ?? '',
            categoryName: item.categoryName ?? '',
            imageUrl: item.imageUrl ?? '',
          );
        }).toList() ??
        [];
  }
}
