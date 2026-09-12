import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/search_and_filtering/search/domain/repositories/search_repository.dart';
import 'package:flowrist/features/home/search_and_filtering/search/domain/use_cases/search_products_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_products_use_case_test.mocks.dart';

@GenerateMocks([SearchRepository])
void main() {
  late MockSearchRepository mockRepository;
  late SearchProductsUseCase useCase;

  setUp(() {
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessResponse<List<ProductEntity>>([]),
    );
    mockRepository = MockSearchRepository();
    useCase = SearchProductsUseCase(mockRepository);
  });

  const tQuery = 'Rose';
  const tSort = 'price_asc';
  const tPage = 1;
  const tPageSize = 20;

  final tProducts = [
    const ProductEntity(
      id: '1',
      name: 'Red Rose',
      price: 100.0,
      discountPercentage: null,
      discountPrice: null,
      inStock: true,
      categoryId: 'cat_1',
      categoryName: 'Flowers',
      imageUrl: 'https://example.com/rose.png',
    ),
  ];

  test(
    'should forward parameters correctly to repository and return SuccessResponse',
    () async {
      when(
        mockRepository.searchProducts(
          query: tQuery,
          sort: tSort,
          page: tPage,
          pageSize: tPageSize,
        ),
      ).thenAnswer(
        (_) async => SuccessResponse<List<ProductEntity>>(tProducts),
      );

      final result = await useCase(
        query: tQuery,
        sort: tSort,
        page: tPage,
        pageSize: tPageSize,
      );

      expect(result, isA<SuccessResponse<List<ProductEntity>>>());
      expect(
        (result as SuccessResponse<List<ProductEntity>>).data,
        equals(tProducts),
      );
      verify(
        mockRepository.searchProducts(
          query: tQuery,
          sort: tSort,
          page: tPage,
          pageSize: tPageSize,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return ErrorResponse when repository returns an ErrorResponse',
    () async {
      const tErrorMessage = 'Failed to fetch search results';
      when(
        mockRepository.searchProducts(
          query: tQuery,
          sort: null,
          page: null,
          pageSize: null,
        ),
      ).thenAnswer(
        (_) async => ErrorResponse<List<ProductEntity>>(tErrorMessage),
      );

      final result = await useCase(query: tQuery);

      expect(result, isA<ErrorResponse<List<ProductEntity>>>());
      expect(
        (result as ErrorResponse<List<ProductEntity>>).errorMessage,
        equals(tErrorMessage),
      );
      verify(
        mockRepository.searchProducts(
          query: tQuery,
          sort: null,
          page: null,
          pageSize: null,
        ),
      ).called(1);
    },
  );
}
