import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';
import 'package:flowrist/features/home/categories/domain/repositories/categories_repository.dart';
import 'package:flowrist/features/home/categories/domain/use_cases/get_categories_use_case.dart';

import 'get_categories_use_case_test.mocks.dart';

@GenerateMocks([CategoriesRepository])
void main() {
  late GetCategoriesUseCase useCase;
  late MockCategoriesRepository mockRepository;

  setUpAll(() {
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessResponse<List<CategoryEntity>>([]),
    );
  });

  setUp(() {
    mockRepository = MockCategoriesRepository();
    useCase = GetCategoriesUseCase(mockRepository);
  });

  final tCategories = [
    const CategoryEntity(id: '1', name: 'Roses', iconUrl: 'icon.png'),
  ];

  test('should return list of CategoryEntity on success', () async {
    when(
      mockRepository.getCategories(),
    ).thenAnswer((_) async => SuccessResponse(tCategories));

    final result = await useCase();

    expect(result, isA<SuccessResponse<List<CategoryEntity>>>());
    expect((result as SuccessResponse).data, tCategories);
    verify(mockRepository.getCategories()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
