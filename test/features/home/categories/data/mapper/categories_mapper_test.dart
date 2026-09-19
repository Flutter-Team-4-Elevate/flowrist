import 'package:flowrist/features/home/categories/data/mapper/categories_mapper.dart';
import 'package:flowrist/features/home/categories/data/models/response/categories_response_dto.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoriesMapper - toCategoryEntities', () {
    test(
      'should map CategoriesResponseDto to List<CategoryEntity> correctly',
      () {
        // Arrange
        const dto = CategoriesResponseDto(
          data: [
            CategoryDto(
              id: '1',
              name: 'Roses',
              iconUrl: 'https://img.com/roses',
            ),
            CategoryDto(
              id: '2',
              name: 'Tulips',
              iconUrl: 'https://img.com/tulips',
            ),
          ],
        );

        // Act
        final result = CategoriesMapper.toCategoryEntities(dto);

        // Assert
        expect(result.length, 2);
        expect(result, const [
          CategoryEntity(
            id: '1',
            name: 'Roses',
            iconUrl: 'https://img.com/roses',
          ),
          CategoryEntity(
            id: '2',
            name: 'Tulips',
            iconUrl: 'https://img.com/tulips',
          ),
        ]);
      },
    );

    test('should handle null fields in CategoryDto with fallback defaults', () {
      // Arrange
      const dto = CategoriesResponseDto(
        data: [CategoryDto(id: null, name: null, iconUrl: null)],
      );

      // Act
      final result = CategoriesMapper.toCategoryEntities(dto);

      // Assert
      expect(result.length, 1);
      expect(result.first.id, '');
      expect(result.first.name, '');
      expect(result.first.iconUrl, '');
    });

    test('should return empty list when data is null', () {
      // Arrange
      const dto = CategoriesResponseDto(data: null);

      // Act
      final result = CategoriesMapper.toCategoryEntities(dto);

      // Assert
      expect(result, isEmpty);
    });
  });
}
