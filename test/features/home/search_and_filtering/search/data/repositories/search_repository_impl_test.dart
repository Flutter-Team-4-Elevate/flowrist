import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/search_and_filtering/search/data/data_sources/contract/search_remote_data_source.dart';
import 'package:flowrist/features/home/search_and_filtering/search/data/models/response/search_response_dto.dart';
import 'package:flowrist/features/home/search_and_filtering/search/data/repositories/search_repository_impl.dart';
import 'package:flowrist/features/home/search_and_filtering/search/domain/repositories/search_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_repository_impl_test.mocks.dart';

@GenerateMocks([SearchRemoteDataSource])
void main() {
  late MockSearchRemoteDataSource mockRemoteDataSource;
  late SearchRepository repository;

  setUp(() {
    mockRemoteDataSource = MockSearchRemoteDataSource();
    repository = SearchRepositoryImpl(mockRemoteDataSource);
  });

  const tQuery = 'Rose';
  const tResponseDto = SearchResponseDto(
    status: true,
    code: 200,
    message: 'Success',
    data: [
      SearchProductItemDto(
        id: '1',
        name: 'Red Rose',
        price: 100,
        discountPercentage: 10,
        discountPrice: 90,
        inStock: true,
        categoryId: 'cat_1',
        categoryName: 'Flowers',
        imageUrl: 'https://example.com/rose.png',
      ),
    ],
  );

  test(
    'should return SuccessResponse<List<ProductEntity>> when remote data source succeeds',
    () async {
      when(
        mockRemoteDataSource.searchProducts(
          query: tQuery,
          sort: anyNamed('sort'),
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
        ),
      ).thenAnswer((_) async => tResponseDto);

      final result = await repository.searchProducts(query: tQuery);

      expect(result, isA<SuccessResponse<List<ProductEntity>>>());
      final data = (result as SuccessResponse<List<ProductEntity>>).data;
      expect(data, isNotNull);
      expect(data!.length, 1);
      expect(data.first.id, '1');
      expect(data.first.name, 'Red Rose');
      expect(data.first.price, 100.0);

      verify(
        mockRemoteDataSource.searchProducts(
          query: tQuery,
          sort: null,
          page: null,
          pageSize: null,
        ),
      ).called(1);
    },
  );

  test(
    'should return ErrorResponse when remote data source throws an Exception',
    () async {
      when(
        mockRemoteDataSource.searchProducts(
          query: tQuery,
          sort: anyNamed('sort'),
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
        ),
      ).thenThrow(Exception('Server error'));

      final result = await repository.searchProducts(query: tQuery);

      expect(result, isA<ErrorResponse<List<ProductEntity>>>());
      verify(
        mockRemoteDataSource.searchProducts(
          query: tQuery,
          sort: null,
          page: null,
          pageSize: null,
        ),
      ).called(1);
    },
  );
}
