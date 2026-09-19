import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/categories/data/data_sources/contract/remote/categories_remote_data_source.dart';
import 'package:flowrist/features/home/categories/data/models/response/categories_response_dto.dart';
import 'package:flowrist/features/home/categories/data/repositories/categories_repository_impl.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';

import 'categories_repository_impl_test.mocks.dart';

@GenerateMocks([CategoriesRemoteDataSource])
void main() {
  late CategoriesRepositoryImpl repository;
  late MockCategoriesRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessResponse<List<CategoryEntity>>([]),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockCategoriesRemoteDataSource();
    repository = CategoriesRepositoryImpl(mockRemoteDataSource);
  });

  test(
    'should return SuccessResponse when remote data source is successful',
    () async {
      const tResponseDto = CategoriesResponseDto(
        data: [CategoryDto(id: '1', name: 'Roses', iconUrl: 'rose.png')],
      );
      when(
        mockRemoteDataSource.getCategories(),
      ).thenAnswer((_) async => tResponseDto);

      final result = await repository.getCategories();

      expect(result, isA<SuccessResponse<List<CategoryEntity>>>());
      expect((result as SuccessResponse).data?.first.name, 'Roses');
    },
  );

  test('should return ErrorResponse when exception occurs', () async {
    when(
      mockRemoteDataSource.getCategories(),
    ).thenThrow(Exception('Network Error'));

    final result = await repository.getCategories();

    expect(result, isA<ErrorResponse<List<CategoryEntity>>>());
  });
}
