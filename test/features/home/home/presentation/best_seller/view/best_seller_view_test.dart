import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_products_use_case.dart';
import 'package:flowrist/features/home/home/presentation/best_seller/cubit/best_seller_cubit.dart';
import 'package:flowrist/features/home/home/presentation/best_seller/cubit/best_seller_events.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../../categories/presentation/view/categories_tab_view_test.mocks.dart';

@GenerateMocks([GetProductsUseCase])
void main() {
  late MockGetProductsUseCase mockGetProductsUseCase;
  late BestSellerCubit cubit;

  setUp(() {
    mockGetProductsUseCase = MockGetProductsUseCase();

    cubit = BestSellerCubit(mockGetProductsUseCase);

    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessResponse<List<ProductEntity>>([]),
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('Test emit products successfully for best seller', () async {
    final products = [
      ProductEntity(
        id: '1',
        price: 600,
        imageUrl: 'https://example.com/rose.jpg',
        name: 'Red Rose',
        inStock: true,
        categoryId: '1',
        categoryName: 'Roses',
      ),
      ProductEntity(
        id: '2',
        price: 700,
        imageUrl: 'https://example.com/white-rose.jpg',
        name: 'White Rose',
        inStock: true,
        categoryId: '1',
        categoryName: 'Roses',
      ),
    ];

    when(
      mockGetProductsUseCase(categoryId: '1'),
    ).thenAnswer((_) async => SuccessResponse<List<ProductEntity>>(products));

    await cubit.doEvent(GetBestSellerProductsEvent('1'));

    expect(cubit.state.products.isLoading, false);
    expect(cubit.state.products.errorMessage, isNull);
    expect(cubit.state.products.data, products);

    verify(mockGetProductsUseCase(categoryId: '1')).called(1);
  });

  test('Test emit empty products successfully for best seller', () async {
    final products = <ProductEntity>[];

    when(
      mockGetProductsUseCase(categoryId: '1'),
    ).thenAnswer((_) async => SuccessResponse<List<ProductEntity>>(products));

    await cubit.doEvent(GetBestSellerProductsEvent('1'));

    expect(cubit.state.products.isLoading, false);
    expect(cubit.state.products.errorMessage, isNull);
    expect(cubit.state.products.data, isEmpty);

    verify(mockGetProductsUseCase(categoryId: '1')).called(1);
  });

  test('Test emit error when getting best seller products fails', () async {
    const errorMessage = 'Failed to load best seller products';

    when(
      mockGetProductsUseCase(categoryId: '1'),
    ).thenAnswer((_) async => ErrorResponse<List<ProductEntity>>(errorMessage));

    await cubit.doEvent(GetBestSellerProductsEvent('1'));

    expect(cubit.state.products.isLoading, false);
    expect(cubit.state.products.errorMessage, errorMessage);
    expect(cubit.state.products.data, isNull);

    verify(mockGetProductsUseCase(categoryId: '1')).called(1);
  });
}