import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';
import 'package:flowrist/features/home/categories/domain/use_cases/get_categories_use_case.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_cubit.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_events.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_products_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_tab_view_test.mocks.dart';

@GenerateMocks([GetCategoriesUseCase, GetProductsUseCase])
void main() {
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetProductsUseCase mockGetProductsUseCase;
  late CategoriesCubit cubit;

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockGetProductsUseCase = MockGetProductsUseCase();

    cubit = CategoriesCubit(mockGetCategoriesUseCase, mockGetProductsUseCase);

    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessResponse<List<CategoryEntity>>([]),
    );

    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessResponse<List<ProductEntity>>([]),
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test(
    'Test emit categories successfully and load products for first category',
    () async {
      final categories = [
        CategoryEntity(
          id: '1',
          name: 'Roses',
          iconUrl: 'https://example.com/roses.jpg',
        ),
        CategoryEntity(
          id: '2',
          name: 'Flowers',
          iconUrl: 'https://example.com/flowers.jpg',
        ),
      ];

      final products = <ProductEntity>[];

      when(mockGetCategoriesUseCase()).thenAnswer(
        (_) async => SuccessResponse<List<CategoryEntity>>(categories),
      );

      when(
        mockGetProductsUseCase(categoryId: '1'),
      ).thenAnswer((_) async => SuccessResponse<List<ProductEntity>>(products));

      await cubit.doEvent(GetCategoriesEvent());

      expect(cubit.state.categories.isLoading, false);
      expect(cubit.state.categories.errorMessage, isNull);
      expect(cubit.state.categories.data, categories);
      expect(cubit.state.selectedIndex, 0);

      expect(cubit.state.products.isLoading, false);
      expect(cubit.state.products.errorMessage, isNull);
      expect(cubit.state.products.data, products);

      verify(mockGetCategoriesUseCase()).called(1);

      verify(mockGetProductsUseCase(categoryId: '1')).called(1);
    },
  );

  test('Test emit empty categories and should not load products', () async {
    final categories = <CategoryEntity>[];

    when(mockGetCategoriesUseCase()).thenAnswer(
      (_) async => SuccessResponse<List<CategoryEntity>>(categories),
    );

    await cubit.doEvent(GetCategoriesEvent());

    expect(cubit.state.categories.isLoading, false);
    expect(cubit.state.categories.errorMessage, isNull);
    expect(cubit.state.categories.data, isEmpty);

    expect(cubit.state.selectedIndex, 0);

    verify(mockGetCategoriesUseCase()).called(1);

    verifyNever(mockGetProductsUseCase(categoryId: anyNamed('categoryId')));
  });

  test('Test emit error when getting categories fails', () async {
    const errorMessage = 'Failed to load categories';

    when(mockGetCategoriesUseCase()).thenAnswer(
      (_) async => ErrorResponse<List<CategoryEntity>>(errorMessage),
    );

    await cubit.doEvent(GetCategoriesEvent());

    expect(cubit.state.categories.isLoading, false);
    expect(cubit.state.categories.errorMessage, errorMessage);
    expect(cubit.state.categories.data, isNull);

    verify(mockGetCategoriesUseCase()).called(1);

    verifyNever(mockGetProductsUseCase(categoryId: anyNamed('categoryId')));
  });

  test('Test emit products successfully for selected category', () async {
    final products = [
      ProductEntity(
        id: '1',
        price: 600,
        imageUrl: 'https://example.com/rose.jpg',
        name: '',
        inStock: false,
        categoryId: '',
        categoryName: '',
      ),
    ];

    when(
      mockGetProductsUseCase(categoryId: '1'),
    ).thenAnswer((_) async => SuccessResponse<List<ProductEntity>>(products));

    await cubit.doEvent(GetProductsByCategoryEvent('1'));

    expect(cubit.state.products.isLoading, false);
    expect(cubit.state.products.errorMessage, isNull);
    expect(cubit.state.products.data, products);

    verify(mockGetProductsUseCase(categoryId: '1')).called(1);
  });

  test('Test emit error when getting products fails', () async {
    const errorMessage = 'Failed to load products';

    when(
      mockGetProductsUseCase(categoryId: '1'),
    ).thenAnswer((_) async => ErrorResponse<List<ProductEntity>>(errorMessage));

    await cubit.doEvent(GetProductsByCategoryEvent('1'));

    expect(cubit.state.products.isLoading, false);
    expect(cubit.state.products.errorMessage, errorMessage);
    expect(cubit.state.products.data, isNull);

    verify(mockGetProductsUseCase(categoryId: '1')).called(1);
  });

  test(
    'Test invalid category index does not change state or load products',
    () async {
      final categories = [
        CategoryEntity(
          id: '1',
          name: 'Roses',
          iconUrl: 'https://example.com/roses.jpg',
        ),
        CategoryEntity(
          id: '2',
          name: 'Flowers',
          iconUrl: 'https://example.com/flowers.jpg',
        ),
      ];

      cubit.emit(
        cubit.state.copyWith(
          categories: cubit.state.categories.copyWith(data: categories),
          selectedIndex: 0,
        ),
      );

      await cubit.doEvent(SelectCategoryEvent(5));

      expect(cubit.state.selectedIndex, 0);

      verifyNever(mockGetProductsUseCase(categoryId: anyNamed('categoryId')));
    },
  );

  test(
    'Test select category when categories data is null does nothing',
    () async {
      await cubit.doEvent(SelectCategoryEvent(0));

      expect(cubit.state.selectedIndex, 0);

      verifyNever(mockGetProductsUseCase(categoryId: anyNamed('categoryId')));
    },
  );
}