import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/features/home/home/data/mapper/occasions_mapper.dart';
import 'package:flowrist/features/home/home/data/models/occasions/occasions_response_dto.dart';
import 'package:flowrist/features/home/home/data/models/occasions/products_response_dto.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/occasion_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';

void main() {
  group('OccasionsMapper', () {
    test('toOccasionEntities should map OccasionsResponseDto correctly', () {
      const dto = OccasionsResponseDto(
        data: [
          OccasionDto(id: '1', name: 'Wedding', imageUrl: 'wedding.png'),
          OccasionDto(id: null, name: null, imageUrl: null),
        ],
      );

      final result = OccasionsMapper.toOccasionEntities(dto);

      expect(result.length, 2);
      expect(
        result[0],
        const OccasionEntity(id: '1', name: 'Wedding', imageUrl: 'wedding.png'),
      );
      expect(result[1], const OccasionEntity(id: '', name: '', imageUrl: ''));
    });

    test('toProductEntities should map ProductsResponseDto correctly', () {
      const dto = ProductsResponseDto(
        data: [
          ProductDto(
            id: 'p1',
            name: 'Rose Box',
            price: 200.0,
            inStock: true,
            categoryId: 'c1',
            categoryName: 'Boxes',
            imageUrl: 'box.png',
          ),
          ProductDto(
            id: null,
            name: null,
            price: null,
            inStock: null,
            categoryId: null,
            categoryName: null,
            imageUrl: null,
          ),
        ],
      );

      final result = OccasionsMapper.toProductEntities(dto);

      expect(result.length, 2);
      expect(
        result[0],
        const ProductEntity(
          id: 'p1',
          name: 'Rose Box',
          price: 200.0,
          inStock: true,
          categoryId: 'c1',
          categoryName: 'Boxes',
          imageUrl: 'box.png',
        ),
      );
      expect(
        result[1],
        const ProductEntity(
          id: '',
          name: '',
          price: 0.0,
          inStock: false,
          categoryId: '',
          categoryName: '',
          imageUrl: '',
        ),
      );
    });
  });
}
