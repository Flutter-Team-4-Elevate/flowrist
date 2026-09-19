import 'package:flowrist/features/home/search_and_filtering/search/data/mapper/search_mapper.dart';
import 'package:flowrist/features/home/search_and_filtering/search/data/models/response/search_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchMapper.toProductEntityList', () {
    test('should map SearchResponseDto to List<ProductEntity> correctly', () {
      const dto = SearchResponseDto(
        status: true,
        code: 200,
        data: [
          SearchProductItemDto(
            id: 'prod_1',
            name: 'Red Rose',
            price: 150.0,
            discountPercentage: 10,
            discountPrice: 135.0,
            inStock: true,
            categoryId: 'cat_1',
            categoryName: 'Flowers',
            imageUrl: 'https://example.com/rose.png',
          ),
        ],
      );

      final result = SearchMapper.toProductEntityList(dto);

      expect(result.length, 1);
      final entity = result.first;
      expect(entity.id, 'prod_1');
      expect(entity.name, 'Red Rose');
      expect(entity.price, 150.0);
      expect(entity.discountPercentage, 10.0);
      expect(entity.discountPrice, 135.0);
      expect(entity.inStock, isTrue);
      expect(entity.categoryId, 'cat_1');
      expect(entity.categoryName, 'Flowers');
      expect(entity.imageUrl, 'https://example.com/rose.png');
    });

    test(
      'should filter out items with null or empty id and handle null fields with defaults',
      () {
        const dto = SearchResponseDto(
          data: [
            SearchProductItemDto(id: null, name: 'Invalid 1'),
            SearchProductItemDto(id: '', name: 'Invalid 2'),
            SearchProductItemDto(
              id: 'valid_id',
              name: null,
              price: null,
              discountPercentage: null,
              discountPrice: null,
              inStock: null,
              categoryId: null,
              categoryName: null,
              imageUrl: null,
            ),
          ],
        );

        final result = SearchMapper.toProductEntityList(dto);

        expect(result.length, 1);
        final entity = result.first;
        expect(entity.id, 'valid_id');
        expect(entity.name, '');
        expect(entity.price, 0.0);
        expect(entity.discountPercentage, isNull);
        expect(entity.discountPrice, isNull);
        expect(entity.inStock, isTrue);
        expect(entity.categoryId, '');
        expect(entity.categoryName, '');
        expect(entity.imageUrl, '');
      },
    );

    test('should return an empty list when data in dto is null or empty', () {
      const dtoWithNullData = SearchResponseDto(data: null);
      const dtoWithEmptyData = SearchResponseDto(data: []);

      expect(SearchMapper.toProductEntityList(dtoWithNullData), isEmpty);
      expect(SearchMapper.toProductEntityList(dtoWithEmptyData), isEmpty);
    });
  });
}
