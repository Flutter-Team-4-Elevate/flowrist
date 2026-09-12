import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/shared/product_details/data/client/product_details_api_client.dart';
import 'package:flowrist/features/home/shared/product_details/data/models/product_details_request_dto.dart';
import 'package:flowrist/features/home/shared/product_details/data/models/product_details_response_dto.dart';
import 'package:flowrist/features/home/shared/product_details/data/data_source/impl/remote/product_details_remote_data_source_impl.dart';

import 'product_details_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProductDetailsApiClient])
void main() {
  late MockProductDetailsApiClient mockApiClient;
  late ProductRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockProductDetailsApiClient();
    dataSource = ProductRemoteDataSourceImpl(mockApiClient);
  });

  final product = ProductDetailsRequestDto(
    id: '33333333-3333-3333-3333-333333333333',
    name: '15 Pink Rose Bouquet',
    price: 1500.0,
    discountedPrice: 1200.0,
    discountPercent: 20.0,
    inStock: true,
    images: [
      'https://example.com/products/pink-rose-bouquet-1.jpg',
      'https://example.com/products/pink-rose-bouquet-2.jpg',
    ],
    description:
    'A beautiful bouquet of 15 fresh pink roses wrapped in elegant white paper.',
    includes: [
      'Pink roses: 15',
      'White wrap',
    ],
    availabilityStatus: 'IN_STOCK',
    availableStock: 10,
    categoryIds: [
      '11111111-1111-1111-1111-111111111111',
    ],
    occasionIds: [
      '22222222-2222-2222-2222-000000000003',
      '22222222-2222-2222-2222-000000000001',
    ],
    createdAt: DateTime.parse(
      '2026-08-14T00:47:42.5841309',
    ),
    updatedAt: DateTime.parse(
      '2026-08-14T00:47:42.5841309',
    ),
    lastChangedBy:
    '33333333-3333-3333-3333-333333333333',
  );

  test(
    'should return SuccessResponse when API returns product successfully',
        () async {
      const productId =
          '33333333-3333-3333-3333-333333333333';

      when(
        mockApiClient.getProductDetails(productId),
      ).thenAnswer(
            (_) async => ProductDetailsResponseDto(
          status: true,
          code: 200,
          message: 'Product retrieved',
          data: product,
        ),
      );

      final result =
      await dataSource.getProductDetails(productId);

      expect(
        result,
        isA<SuccessResponse<ProductDetailsRequestDto>>(),
      );

      final success =
      result as SuccessResponse<ProductDetailsRequestDto>;

      expect(success.data, product);

      verify(
        mockApiClient.getProductDetails(productId),
      ).called(1);
    },
  );

  test(
    'should return ErrorResponse when API returns an error',
        () async {
      const productId = 'invalid-id';

      when(
        mockApiClient.getProductDetails(productId),
      ).thenAnswer(
            (_) async => const ProductDetailsResponseDto(
          status: false,
          code: 404,
          message: 'Product not found',
          data: null,
        ),
      );

      final result =
      await dataSource.getProductDetails(productId);

      expect(
        result,
        isA<ErrorResponse<ProductDetailsRequestDto>>(),
      );

      final error =
      result as ErrorResponse<ProductDetailsRequestDto>;

      expect(
        error.errorMessage,
        'Product not found',
      );

      verify(
        mockApiClient.getProductDetails(productId),
      ).called(1);
    },
  );

  test(
    'should return ErrorResponse when API throws an exception',
        () async {
      const productId =
          '33333333-3333-3333-3333-333333333333';

      when(
        mockApiClient.getProductDetails(productId),
      ).thenThrow(
        Exception('Network error'),
      );

      final result =
      await dataSource.getProductDetails(productId);

      expect(
        result,
        isA<ErrorResponse<ProductDetailsRequestDto>>(),
      );

      final error =
      result as ErrorResponse<ProductDetailsRequestDto>;

      expect(
        error.errorMessage,
        contains('Network error'),
      );

      verify(
        mockApiClient.getProductDetails(productId),
      ).called(1);
    },
  );
}