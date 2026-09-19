import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';
import 'package:flowrist/features/home/categories/domain/use_cases/get_categories_use_case.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_cubit.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_events.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_state.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_products_use_case.dart';
import 'package:flowrist/features/home/search_and_filtering/filter/models/sort_option.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_cubit_test.mocks.dart';

@GenerateMocks([GetCategoriesUseCase, GetProductsUseCase])
void main() {
  late CategoriesCubit cubit;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetProductsUseCase mockGetProductsUseCase;

  const tCategories = [
    CategoryEntity(id: 'cat1', name: 'Roses', iconUrl: 'icon1.png'),
    CategoryEntity(id: 'cat2', name: 'Tulips', iconUrl: 'icon2.png'),
  ];

  const tProducts = [
    ProductEntity(
      id: 'p1',
      name: 'Red Rose',
      price: 50.0,
      inStock: true,
      categoryId: 'cat1',
      categoryName: 'Roses',
      imageUrl: 'rose.png',
    ),
  ];

  setUpAll(() {
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessResponse<List<CategoryEntity>>([]),
    );
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessResponse<List<ProductEntity>>([]),
    );
  });

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockGetProductsUseCase = MockGetProductsUseCase();
    cubit = CategoriesCubit(mockGetCategoriesUseCase, mockGetProductsUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('GetCategoriesEvent', () {
    blocTest<CategoriesCubit, CategoriesState>(
      'should emit loading then categories and fetch products on success',
      build: () {
        when(
          mockGetCategoriesUseCase(),
        ).thenAnswer((_) async => SuccessResponse(tCategories));
        when(
          mockGetProductsUseCase(categoryId: 'cat1', sort: null),
        ).thenAnswer((_) async => SuccessResponse(tProducts));
        return cubit;
      },
      act: (cubit) => cubit.doEvent(GetCategoriesEvent()),
      expect: () => [
        // 1. Categories Loading
        isA<CategoriesState>().having(
          (s) => s.categories.isLoading,
          'categories.isLoading',
          true,
        ),
        // 2. Categories Loaded & Selected Index set
        isA<CategoriesState>()
            .having((s) => s.categories.data, 'categories.data', tCategories)
            .having(
              (s) => s.categories.isLoading,
              'categories.isLoading',
              false,
            )
            .having((s) => s.selectedIndex, 'selectedIndex', 0),
        // 3. Products Loading
        isA<CategoriesState>().having(
          (s) => s.products.isLoading,
          'products.isLoading',
          true,
        ),
        // 4. Products Loaded
        isA<CategoriesState>()
            .having((s) => s.products.data, 'products.data', tProducts)
            .having((s) => s.products.isLoading, 'products.isLoading', false),
      ],
      verify: (_) {
        verify(mockGetCategoriesUseCase()).called(1);
        verify(
          mockGetProductsUseCase(categoryId: 'cat1', sort: null),
        ).called(1);
      },
    );
  });

  group('ApplySortEvent', () {
    blocTest<CategoriesCubit, CategoriesState>(
      'should update selectedSort and fetch products with new sort param',
      build: () {
        when(
          mockGetProductsUseCase(
            categoryId: 'cat1',
            sort: SortOption.lowestPrice.apiValue,
          ),
        ).thenAnswer((_) async => SuccessResponse(tProducts));
        return cubit;
      },
      seed: () => CategoriesState.initial().copyWith(
        categories: CategoriesState.initial().categories.copyWith(
          data: tCategories,
          isLoading: false,
        ),
        selectedIndex: 0,
      ),
      act: (cubit) => cubit.doEvent(ApplySortEvent(SortOption.lowestPrice)),
      expect: () => [
        // 1. Sort state updated
        isA<CategoriesState>().having(
          (s) => s.selectedSort,
          'selectedSort',
          SortOption.lowestPrice,
        ),
        // 2. Products loading
        isA<CategoriesState>().having(
          (s) => s.products.isLoading,
          'products.isLoading',
          true,
        ),
        // 3. Products loaded
        isA<CategoriesState>()
            .having((s) => s.products.data, 'products.data', tProducts)
            .having((s) => s.products.isLoading, 'products.isLoading', false),
      ],
      verify: (_) {
        verify(
          mockGetProductsUseCase(
            categoryId: 'cat1',
            sort: SortOption.lowestPrice.apiValue,
          ),
        ).called(1);
      },
    );

    blocTest<CategoriesCubit, CategoriesState>(
      'should clear sort and fetch products without sort param when sortOption is null',
      build: () {
        when(
          mockGetProductsUseCase(categoryId: 'cat1', sort: null),
        ).thenAnswer((_) async => SuccessResponse(tProducts));
        return cubit;
      },
      seed: () => CategoriesState.initial().copyWith(
        categories: CategoriesState.initial().categories.copyWith(
          data: tCategories,
          isLoading: false,
        ),
        selectedIndex: 0,
        selectedSort: SortOption.lowestPrice,
      ),
      act: (cubit) => cubit.doEvent(ApplySortEvent(null)),
      expect: () => [
        // 1. Sort cleared
        isA<CategoriesState>().having(
          (s) => s.selectedSort,
          'selectedSort',
          isNull,
        ),
        // 2. Products loading
        isA<CategoriesState>().having(
          (s) => s.products.isLoading,
          'products.isLoading',
          true,
        ),
        // 3. Products loaded
        isA<CategoriesState>()
            .having((s) => s.products.data, 'products.data', tProducts)
            .having((s) => s.products.isLoading, 'products.isLoading', false),
      ],
      verify: (_) {
        verify(
          mockGetProductsUseCase(categoryId: 'cat1', sort: null),
        ).called(1);
      },
    );
  });

  group('SelectCategoryEvent', () {
    blocTest<CategoriesCubit, CategoriesState>(
      'should update selectedIndex, keep current sort, and fetch products',
      build: () {
        when(
          mockGetProductsUseCase(
            categoryId: 'cat2',
            sort: SortOption.highestPrice.apiValue,
          ),
        ).thenAnswer((_) async => SuccessResponse(tProducts));
        return cubit;
      },
      seed: () => CategoriesState.initial().copyWith(
        categories: CategoriesState.initial().categories.copyWith(
          data: tCategories,
          isLoading: false,
        ),
        selectedIndex: 0,
        selectedSort: SortOption.highestPrice,
      ),
      act: (cubit) => cubit.doEvent(SelectCategoryEvent(1)),
      expect: () => [
        // 1. Category index updated
        isA<CategoriesState>().having(
          (s) => s.selectedIndex,
          'selectedIndex',
          1,
        ),
        // 2. Products loading
        isA<CategoriesState>().having(
          (s) => s.products.isLoading,
          'products.isLoading',
          true,
        ),
        // 3. Products loaded
        isA<CategoriesState>()
            .having((s) => s.products.data, 'products.data', tProducts)
            .having((s) => s.products.isLoading, 'products.isLoading', false),
      ],
      verify: (_) {
        verify(
          mockGetProductsUseCase(
            categoryId: 'cat2',
            sort: SortOption.highestPrice.apiValue,
          ),
        ).called(1);
      },
    );
  });

  group('GetCategoriesEvent - Failure & Empty', () {
    blocTest<CategoriesCubit, CategoriesState>(
      'should emit error when getCategories fails',
      build: () {
        when(
          mockGetCategoriesUseCase(),
        ).thenAnswer((_) async => ErrorResponse('Network Error'));
        return cubit;
      },
      act: (cubit) => cubit.doEvent(GetCategoriesEvent()),
      expect: () => [
        isA<CategoriesState>().having(
          (s) => s.categories.isLoading,
          'categories.isLoading',
          true,
        ),
        isA<CategoriesState>()
            .having(
              (s) => s.categories.isLoading,
              'categories.isLoading',
              false,
            )
            .having(
              (s) => s.categories.errorMessage,
              'categories.errorMessage',
              'Network Error',
            ),
      ],
    );

    blocTest<CategoriesCubit, CategoriesState>(
      'should emit empty categories and not load products when categories list is empty',
      build: () {
        when(
          mockGetCategoriesUseCase(),
        ).thenAnswer((_) async => SuccessResponse(<CategoryEntity>[]));
        return cubit;
      },
      act: (cubit) => cubit.doEvent(GetCategoriesEvent()),
      expect: () => [
        isA<CategoriesState>().having(
          (s) => s.categories.isLoading,
          'categories.isLoading',
          true,
        ),
        isA<CategoriesState>()
            .having((s) => s.categories.data, 'categories.data', isEmpty)
            .having(
              (s) => s.categories.isLoading,
              'categories.isLoading',
              false,
            ),
      ],
    );
  });

  group('ApplySortEvent - Error Handling', () {
    blocTest<CategoriesCubit, CategoriesState>(
      'should emit error message when products fetch fails after applying sort',
      build: () {
        when(
          mockGetProductsUseCase(
            categoryId: 'cat1',
            sort: SortOption.lowestPrice.apiValue,
          ),
        ).thenAnswer((_) async => ErrorResponse('Failed to fetch'));
        return cubit;
      },
      seed: () => CategoriesState.initial().copyWith(
        categories: CategoriesState.initial().categories.copyWith(
          data: tCategories,
          isLoading: false,
        ),
        selectedIndex: 0,
      ),
      act: (cubit) => cubit.doEvent(ApplySortEvent(SortOption.lowestPrice)),
      expect: () => [
        // 1. Sort state updated
        isA<CategoriesState>().having(
          (s) => s.selectedSort,
          'selectedSort',
          SortOption.lowestPrice,
        ),
        // 2. Products loading
        isA<CategoriesState>().having(
          (s) => s.products.isLoading,
          'products.isLoading',
          true,
        ),
        // 3. Products error
        isA<CategoriesState>()
            .having(
              (s) => s.products.errorMessage,
              'products.errorMessage',
              'Failed to fetch',
            )
            .having((s) => s.products.isLoading, 'products.isLoading', false),
      ],
    );
  });
}
