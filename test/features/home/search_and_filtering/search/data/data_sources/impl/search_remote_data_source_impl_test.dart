import 'package:flowrist/features/home/search_and_filtering/search/data/client/search_api_client.dart';
import 'package:flowrist/features/home/search_and_filtering/search/data/data_sources/contract/search_remote_data_source.dart';
import 'package:flowrist/features/home/search_and_filtering/search/data/data_sources/impl/search_remote_data_source_impl.dart';
import 'package:flowrist/features/home/search_and_filtering/search/data/models/response/search_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([SearchApiClient])
void main() {
  late MockSearchApiClient mockApiClient;
  late SearchRemoteDataSource dataSource;

  setUp(() {
    mockApiClient = MockSearchApiClient();
    dataSource = SearchRemoteDataSourceImpl(mockApiClient);
  });

  const tQuery = 'Rose';
  const tSort = 'price_asc';
  const tPage = 1;
  const tPageSize = 20;

  const tResponseDto = SearchResponseDto(
    status: true,
    code: 200,
    message: 'Success',
    data: [SearchProductItemDto(id: '1', name: 'Red Rose', price: 100)],
  );

  test(
    'should call searchProducts on SearchApiClient with matching parameters and return response',
    () async {
      when(
        mockApiClient.searchProducts(
          query: tQuery,
          sort: tSort,
          page: tPage,
          pageSize: tPageSize,
        ),
      ).thenAnswer((_) async => tResponseDto);

      final result = await dataSource.searchProducts(
        query: tQuery,
        sort: tSort,
        page: tPage,
        pageSize: tPageSize,
      );

      expect(result, equals(tResponseDto));
      verify(
        mockApiClient.searchProducts(
          query: tQuery,
          sort: tSort,
          page: tPage,
          pageSize: tPageSize,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockApiClient);
    },
  );

  test('should propagate exception when SearchApiClient fails', () async {
    when(
      mockApiClient.searchProducts(
        query: tQuery,
        sort: anyNamed('sort'),
        page: anyNamed('page'),
        pageSize: anyNamed('pageSize'),
      ),
    ).thenThrow(Exception('API error'));

    expect(
      () => dataSource.searchProducts(query: tQuery),
      throwsA(isA<Exception>()),
    );
  });
}
