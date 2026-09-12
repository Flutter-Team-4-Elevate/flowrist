import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/data/data_sources/contract/remote/occasions_remote_data_source.dart';
import 'package:flowrist/features/home/home/data/models/occasions/occasions_response_dto.dart';
import 'package:flowrist/features/home/home/data/models/occasions/products_response_dto.dart';
import 'package:flowrist/features/home/home/data/repositories/occasions_repository_impl.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/occasion_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'occasions_repository_impl_test.mocks.dart';

@GenerateMocks([OccasionsRemoteDataSource])
void main() {
  late OccasionsRepositoryImpl repository;
  late MockOccasionsRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    provideDummy<BaseResponse<List<OccasionEntity>>>(
      SuccessResponse<List<OccasionEntity>>([]),
    );
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessResponse<List<ProductEntity>>([]),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockOccasionsRemoteDataSource();
    repository = OccasionsRepositoryImpl(mockRemoteDataSource);
  });

  group('getOccasions', () {
    test(
      'should return SuccessResponse<List<OccasionEntity>> when remote call succeeds',
      () async {
        const tResponse = OccasionsResponseDto(
          data: [OccasionDto(id: '1', name: 'Birthday', imageUrl: 'img.png')],
        );
        when(
          mockRemoteDataSource.getOccasions(),
        ).thenAnswer((_) async => tResponse);

        final result = await repository.getOccasions();

        expect(result, isA<SuccessResponse<List<OccasionEntity>>>());
        expect((result as SuccessResponse).data?.first.name, 'Birthday');
      },
    );
  });

  group('getProducts', () {
    test(
      'should return SuccessResponse<List<ProductEntity>> when remote call succeeds with sort param',
      () async {
        const tResponse = ProductsResponseDto(
          data: [ProductDto(id: 'p1', name: 'Flower', price: 100.0)],
        );
        when(
          mockRemoteDataSource.getProducts(
            occasionId: '1',
            categoryId: 'c1',
            sort: 'PriceLowToHigh',
          ),
        ).thenAnswer((_) async => tResponse);

        final result = await repository.getProducts(
          occasionId: '1',
          categoryId: 'c1',
          sort: 'PriceLowToHigh',
        );

        expect(result, isA<SuccessResponse<List<ProductEntity>>>());
        expect((result as SuccessResponse).data?.first.name, 'Flower');
        verify(
          mockRemoteDataSource.getProducts(
            occasionId: '1',
            categoryId: 'c1',
            sort: 'PriceLowToHigh',
          ),
        ).called(1);
      },
    );

    test(
      'should return ErrorResponse when remote call throws exception',
      () async {
        when(
          mockRemoteDataSource.getProducts(
            occasionId: anyNamed('occasionId'),
            categoryId: anyNamed('categoryId'),
            sort: anyNamed('sort'),
          ),
        ).thenThrow(Exception('Server error'));

        final result = await repository.getProducts(occasionId: '1');

        expect(result, isA<ErrorResponse<List<ProductEntity>>>());
      },
    );
  });
}
