import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/occasion_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_occasions_use_case.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_products_use_case.dart';
import 'package:flowrist/features/home/home/presentation/occasion/cubit/occasion_cubit.dart';
import 'package:flowrist/features/home/home/presentation/occasion/cubit/occassion_events.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'occasion_view_test.mocks.dart';

@GenerateMocks([GetOccasionsUseCase, GetProductsUseCase])
void main() {
  late MockGetOccasionsUseCase mockGetOccasionsUseCase;
  late MockGetProductsUseCase mockGetProductsUseCase;
  late OccasionCubit cubit;

  setUp(() {
    mockGetOccasionsUseCase = MockGetOccasionsUseCase();
    mockGetProductsUseCase = MockGetProductsUseCase();
    cubit = OccasionCubit(mockGetOccasionsUseCase, mockGetProductsUseCase);

    provideDummy<BaseResponse<List<OccasionEntity>>>(
      SuccessResponse<List<OccasionEntity>>([]),
    );
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessResponse<List<ProductEntity>>([]),
    );
  });

  tearDown(() async {
    await cubit.close();
  });
  test(
    'Test emit occasions successfully and load products for first occasion',
    () async {
      final occasions = [
        OccasionEntity(
          id: '1',
          name: 'Birthday',
          imageUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSebxfYBpVzVvHtz2v-eH_V2Hn7PR5zKdjHONTtE4LSg&s=10',
        ),
        OccasionEntity(
          id: '2',
          name: 'Wedding',
          imageUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSebxfYBpVzVvHtz2v-eH_V2Hn7PR5zKdjHONTtE4LSg&s=10',
        ),
      ];

      final products = <ProductEntity>[];

      when(mockGetOccasionsUseCase()).thenAnswer(
        (_) async => SuccessResponse<List<OccasionEntity>>(occasions),
      );

      when(
        mockGetProductsUseCase(occasionId: '1'),
      ).thenAnswer((_) async => SuccessResponse<List<ProductEntity>>(products));

      await cubit.doEvent(GetOccasionsEvent());

      expect(cubit.state.occasions.isLoading, false);
      expect(cubit.state.occasions.errorMessage, isNull);
      expect(cubit.state.occasions.data, occasions);
      expect(cubit.state.selectedIndex, 0);

      expect(cubit.state.products.isLoading, false);
      expect(cubit.state.products.data, products);

      verify(mockGetOccasionsUseCase()).called(1);

      verify(mockGetProductsUseCase(occasionId: '1')).called(1);
    },
  );
  test('Test emit empty occasions and should not load products', () async {
    final occasions = <OccasionEntity>[];

    when(
      mockGetOccasionsUseCase(),
    ).thenAnswer((_) async => SuccessResponse<List<OccasionEntity>>(occasions));

    await cubit.doEvent(GetOccasionsEvent());

    expect(cubit.state.occasions.isLoading, false);
    expect(cubit.state.occasions.errorMessage, isNull);
    expect(cubit.state.occasions.data, isEmpty);

    expect(cubit.state.selectedIndex, 0);

    verify(mockGetOccasionsUseCase()).called(1);

    verifyNever(mockGetProductsUseCase(occasionId: anyNamed('occasionId')));
  });
  test('Test emit error when getting occasions fails', () async {
    const errorMessage = 'Failed to load occasions';

    when(mockGetOccasionsUseCase()).thenAnswer(
      (_) async => ErrorResponse<List<OccasionEntity>>(errorMessage),
    );

    await cubit.doEvent(GetOccasionsEvent());

    expect(cubit.state.occasions.isLoading, false);
    expect(cubit.state.occasions.errorMessage, errorMessage);
    expect(cubit.state.occasions.data, isNull);

    verify(mockGetOccasionsUseCase()).called(1);

    verifyNever(mockGetProductsUseCase(occasionId: anyNamed('occasionId')));
  });
  test('Test emit products successfully for selected occasion', () async {
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

    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessResponse<List<ProductEntity>>([]),
    );

    when(
      mockGetProductsUseCase(occasionId: '1'),
    ).thenAnswer((_) async => SuccessResponse<List<ProductEntity>>(products));

    await cubit.doEvent(GetProductsByOccasionEvent('1'));

    expect(cubit.state.products.isLoading, false);
    expect(cubit.state.products.errorMessage, isNull);
    expect(cubit.state.products.data, products);

    verify(mockGetProductsUseCase(occasionId: '1')).called(1);
  });
  test('Test emit error when getting products fails', () async {
    const errorMessage = 'Failed to load products';

    when(
      mockGetProductsUseCase(occasionId: '1'),
    ).thenAnswer((_) async => ErrorResponse<List<ProductEntity>>(errorMessage));

    await cubit.doEvent(GetProductsByOccasionEvent('1'));

    expect(cubit.state.products.isLoading, false);
    expect(cubit.state.products.errorMessage, errorMessage);
    expect(cubit.state.products.data, isNull);

    verify(mockGetProductsUseCase(occasionId: '1')).called(1);
  });
  test(
    'Test invalid occasion index does not change state or load products',
    () async {
      final occasions = [
        OccasionEntity(
          id: '1',
          name: 'Birthday',
          imageUrl: 'https://example.com/birthday.jpg',
        ),
        OccasionEntity(
          id: '2',
          name: 'Wedding',
          imageUrl: 'https://example.com/wedding.jpg',
        ),
      ];

      cubit.emit(
        cubit.state.copyWith(
          occasions: cubit.state.occasions.copyWith(data: occasions),
          selectedIndex: 0,
        ),
      );

      await cubit.doEvent(SelectOccasionEvent(5));

      expect(cubit.state.selectedIndex, 0);

      verifyNever(mockGetProductsUseCase(occasionId: anyNamed('occasionId')));
    },
  );
  test(
    'Test select occasion when occasions data is null does nothing',
    () async {
      await cubit.doEvent(SelectOccasionEvent(0));

      expect(cubit.state.selectedIndex, 0);

      verifyNever(mockGetProductsUseCase(occasionId: anyNamed('occasionId')));
    },
  );
}