import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/features/home/home/data/client/occasions_api_client.dart';
import 'package:flowrist/features/home/home/data/data_sources/impl/remote/occasions_remote_data_source_impl.dart';
import 'package:flowrist/features/home/home/data/models/occasions/occasions_response_dto.dart';
import 'package:flowrist/features/home/home/data/models/occasions/products_response_dto.dart';

import 'occasions_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([OccasionsApiClient])
void main() {
  late OccasionsRemoteDataSourceImpl dataSource;
  late MockOccasionsApiClient mockApiClient;

  setUpAll(() {
    provideDummy<OccasionsResponseDto>(const OccasionsResponseDto());
    provideDummy<ProductsResponseDto>(const ProductsResponseDto());
  });

  setUp(() {
    mockApiClient = MockOccasionsApiClient();
    dataSource = OccasionsRemoteDataSourceImpl(mockApiClient);
  });

  group('getOccasions', () {
    const tResponseDto = OccasionsResponseDto(
      message: 'Success',
      data: [OccasionDto(id: '1', name: 'Birthday')],
    );

    test(
      'should call apiClient.getOccasions and return OccasionsResponseDto',
      () async {
        // Arrange
        when(
          mockApiClient.getOccasions(),
        ).thenAnswer((_) async => tResponseDto);

        // Act
        final result = await dataSource.getOccasions();

        // Assert
        expect(result, tResponseDto);
        verify(mockApiClient.getOccasions()).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('should throw an exception when apiClient fails', () async {
      // Arrange
      when(mockApiClient.getOccasions()).thenThrow(Exception('API error'));

      // Act & Assert
      expect(() => dataSource.getOccasions(), throwsA(isA<Exception>()));
      verify(mockApiClient.getOccasions()).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });

  group('getProducts', () {
    const tOccasionId = 'occ-123';
    const tCategoryId = 'cat-123';
    const tProductsDto = ProductsResponseDto(
      message: 'Success',
      data: [ProductDto(id: 'p1', name: 'Bouquet')],
    );

    test('should call apiClient.getProducts with correct parameters', () async {
      // Arrange
      when(
        mockApiClient.getProducts(
          occasionId: tOccasionId,
          categoryId: tCategoryId,
        ),
      ).thenAnswer((_) async => tProductsDto);

      // Act
      final result = await dataSource.getProducts(
        occasionId: tOccasionId,
        categoryId: tCategoryId,
      );

      // Assert
      expect(result, tProductsDto);
      verify(
        mockApiClient.getProducts(
          occasionId: tOccasionId,
          categoryId: tCategoryId,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('should throw an exception when apiClient fails', () async {
      // Arrange
      when(
        mockApiClient.getProducts(
          occasionId: tOccasionId,
          categoryId: tCategoryId,
        ),
      ).thenThrow(Exception('API error'));

      // Act & Assert
      expect(
        () => dataSource.getProducts(
          occasionId: tOccasionId,
          categoryId: tCategoryId,
        ),
        throwsA(isA<Exception>()),
      );
      verify(
        mockApiClient.getProducts(
          occasionId: tOccasionId,
          categoryId: tCategoryId,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}
