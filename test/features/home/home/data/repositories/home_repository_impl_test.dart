import 'package:flowrist/features/home/home/domain/entities/home_entities/home_layout_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/data/data_sources/contract/remote/home_remote_data_source.dart';
import 'package:flowrist/features/home/home/data/models/home_model/home_response_model.dart';
import 'package:flowrist/features/home/home/data/repositories/home_repository_impl.dart';

import 'home_repository_impl_test.mocks.dart';

@GenerateMocks([HomeRemoteDataSource])
void main() {
  late MockHomeRemoteDataSource mockRemoteDataSource;
  late HomeRepositoryImpl repository;
  setUp(() {
    provideDummy<BaseResponse<List<HomeResponseModel>>>(
      SuccessResponse<List<HomeResponseModel>>([]),
    );
    mockRemoteDataSource = MockHomeRemoteDataSource();
    repository = HomeRepositoryImpl(mockRemoteDataSource);
  });

  group('HomeRepositoryImpl', () {
    test(
      'should return SuccessResponse with mapped entities when remote data source succeeds',
      () async {
        // Arrange
        final models = <HomeResponseModel>[];

        when(
          mockRemoteDataSource.getHomeLayout(),
        ).thenAnswer((_) async => SuccessResponse(models));

        // Act
        final result = await repository.getHomeLayout();

        // Assert
        expect(result, isA<SuccessResponse<List<HomeLayoutEntity>>>());

        final successResponse =
            result as SuccessResponse<List<HomeLayoutEntity>>;

        expect(successResponse.data, isEmpty);

        verify(mockRemoteDataSource.getHomeLayout()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return ErrorResponse when remote data source returns an error',
      () async {
        // Arrange
        const errorMessage = 'Failed to load home layout';

        when(
          mockRemoteDataSource.getHomeLayout(),
        ).thenAnswer((_) async => ErrorResponse(errorMessage));

        // Act
        final result = await repository.getHomeLayout();

        // Assert
        expect(result, isA<ErrorResponse<List<HomeLayoutEntity>>>());

        final errorResponse = result as ErrorResponse<List<HomeLayoutEntity>>;

        expect(errorResponse.errorMessage, errorMessage);

        verify(mockRemoteDataSource.getHomeLayout()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
}
