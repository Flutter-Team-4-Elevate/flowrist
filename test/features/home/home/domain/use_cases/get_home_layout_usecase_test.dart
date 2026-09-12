import 'package:flowrist/features/home/home/domain/use_cases/get_home_layout_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/banner_payload_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/home_layout_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/category_rail_payload_entity.dart';
import 'package:flowrist/features/home/home/domain/repositories/home_repository.dart';

import 'get_home_layout_usecase_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late MockHomeRepository mockRepository;
  late GetHomeLayoutUseCase useCase;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetHomeLayoutUseCase(mockRepository);

    provideDummy<BaseResponse<List<HomeLayoutEntity>>>(
      SuccessResponse<List<HomeLayoutEntity>>([]),
    );
  });

  group('GetHomeLayoutUseCase', () {
    test(
      'should call repository.getHomeLayout and return its response',
      () async {
        // Arrange
        final homeData = [
          HomeLayoutEntity(
            id: '1',
            type: 'banner',
            title: 'Spring Sale',
            order: 1,
            isEnabled: true,
            payload: BannerPayloadEntity(
              imageUrl: 'https://example.com/banner.jpg',
              clickAction: 'flowerapp://promotions', type: '',
            ),
          ),
          HomeLayoutEntity(
            id: '2',
            type: 'category_rail',
            title: 'Categories',
            order: 2,
            isEnabled: true,
            payload: CategoryRailPayloadEntity(
              items: [],
              viewAllAction: 'flowerapp://categories', type: '',
            ),
          ),
        ];

        final response = SuccessResponse<List<HomeLayoutEntity>>(
          homeData,
        );

        when(mockRepository.getHomeLayout())
            .thenAnswer((_) async => response);

        // Act
        final result = await useCase();

        // Assert
        expect(result, same(response));

        expect(result, isA<SuccessResponse<List<HomeLayoutEntity>>>());

        final successResponse =
            result as SuccessResponse<List<HomeLayoutEntity>>;

        expect(successResponse.data, same(homeData));
        expect(successResponse.data, hasLength(2));
        expect(successResponse.data![0].id, '1');
        expect(successResponse.data![0].type, 'banner');
        expect(successResponse.data![1].id, '2');
        expect(successResponse.data![1].type, 'category_rail');

        verify(mockRepository.getHomeLayout()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return ErrorResponse when repository returns an error',
      () async {
        // Arrange
        const errorMessage = 'Failed to load home layout';

        final response = ErrorResponse<List<HomeLayoutEntity>>(
          errorMessage,
        );

        when(mockRepository.getHomeLayout())
            .thenAnswer((_) async => response);

        // Act
        final result = await useCase();

        // Assert
        expect(result, same(response));

        expect(
          result,
          isA<ErrorResponse<List<HomeLayoutEntity>>>(),
        );

        final errorResponse =
            result as ErrorResponse<List<HomeLayoutEntity>>;

        expect(errorResponse.errorMessage, errorMessage);

        verify(mockRepository.getHomeLayout()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}