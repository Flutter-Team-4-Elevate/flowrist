import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/features/home/categories/data/client/categories_api_client.dart';
import 'package:flowrist/features/home/categories/data/data_sources/impl/remote/categories_remote_data_source_impl.dart';
import 'package:flowrist/features/home/categories/data/models/response/categories_response_dto.dart';

import 'categories_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([CategoriesApiClient])
void main() {
  late CategoriesRemoteDataSourceImpl dataSource;
  late MockCategoriesApiClient mockApiClient;

  setUpAll(() {
    provideDummy<CategoriesResponseDto>(const CategoriesResponseDto());
  });

  setUp(() {
    mockApiClient = MockCategoriesApiClient();
    dataSource = CategoriesRemoteDataSourceImpl(mockApiClient);
  });

  group('getCategories', () {
    const tResponseDto = CategoriesResponseDto(
      message: 'Success',
      data: [CategoryDto(id: '1', name: 'Roses')],
    );

    test(
      'should call apiClient.getCategories and return CategoriesResponseDto',
      () async {
        // Arrange
        when(
          mockApiClient.getCategories(),
        ).thenAnswer((_) async => tResponseDto);

        // Act
        final result = await dataSource.getCategories();

        // Assert
        expect(result, tResponseDto);
        verify(mockApiClient.getCategories()).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('should throw an exception when apiClient fails', () async {
      // Arrange
      when(mockApiClient.getCategories()).thenThrow(Exception('API error'));

      // Act & Assert
      expect(() => dataSource.getCategories(), throwsA(isA<Exception>()));
      verify(mockApiClient.getCategories()).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}
