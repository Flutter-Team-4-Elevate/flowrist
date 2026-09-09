import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/remove_cart_item_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/update_cart_quantity_use_case.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  GetCartUseCase,
  AddToCartUseCase,
  UpdateCartQuantityUseCase,
  RemoveCartItemUseCase,
])
import 'cart_cubit_test.mocks.dart';

void main() {
  late MockGetCartUseCase mockGetCartUseCase;
  late MockAddToCartUseCase mockAddToCartUseCase;
  late MockUpdateCartQuantityUseCase mockUpdateCartQuantityUseCase;
  late MockRemoveCartItemUseCase mockRemoveCartItemUseCase;
  late CartCubit cartCubit;

  final tCartItem = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Red Rose Bouquet',
    productImage: 'https://example.com/rose.png',
    unitPrice: 50.0,
    priceAtAdd: 50.0,
    quantity: 2,
    lineSubtotal: 100.0,
    availableStock: 10,
    isAvailable: true,
    priceChanged: false,
    stockChanged: false,
  );

  final tCartEntity = CartEntity(
    cartId: 'cart_123',
    items: [tCartItem],
    totalQuantity: 2,
    lineCount: 1,
    subtotal: 100.0,
    deliveryFee: 20.0,
    total: 120.0,
    hasChanges: false,
  );

  setUp(() {
    provideDummy<BaseResponse<CartEntity>>(
      SuccessResponse<CartEntity>(tCartEntity),
    );
    provideDummy<BaseResponse<void>>(
      SuccessResponse<void>(null),
    );

    mockGetCartUseCase = MockGetCartUseCase();
    mockAddToCartUseCase = MockAddToCartUseCase();
    mockUpdateCartQuantityUseCase = MockUpdateCartQuantityUseCase();
    mockRemoveCartItemUseCase = MockRemoveCartItemUseCase();

    cartCubit = CartCubit(
      mockGetCartUseCase,
      mockAddToCartUseCase,
      mockUpdateCartQuantityUseCase,
      mockRemoveCartItemUseCase,
    );
  });

  tearDown(() {
    cartCubit.close();
  });

  test('initial state should be CartState.initial()', () {
    expect(cartCubit.state, equals(CartState.initial()));
  });

  group('GetCartEvent', () {
    blocTest<CartCubit, CartState>(
      'emits [loading, success] when getCart succeeds',
      build: () {
        when(mockGetCartUseCase()).thenAnswer(
          (_) async => SuccessResponse<CartEntity>(tCartEntity),
        );
        return cartCubit;
      },
      act: (cubit) => cubit.doEvent(GetCartEvent()),
      expect: () => [
        CartState.initial().copyWith(
          cart: BaseState<CartEntity>(
            isLoading: true,
            errorMessage: null,
            data: null,
          ),
        ),
        CartState.initial().copyWith(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tCartEntity,
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetCartUseCase()).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'emits [loading, error] when getCart fails',
      build: () {
        when(mockGetCartUseCase()).thenAnswer(
          (_) async => ErrorResponse<CartEntity>('Failed to fetch cart'),
        );
        return cartCubit;
      },
      act: (cubit) => cubit.doEvent(GetCartEvent()),
      expect: () => [
        CartState.initial().copyWith(
          cart: BaseState<CartEntity>(
            isLoading: true,
            errorMessage: null,
            data: null,
          ),
        ),
        CartState.initial().copyWith(
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: 'Failed to fetch cart',
            data: null,
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetCartUseCase()).called(1);
      },
    );
  });

  group('AddToCartEvent', () {
    final tProductId = 'prod_1';

    blocTest<CartCubit, CartState>(
      'emits [addingProduct, successWithUpdatedCart] when addToCart succeeds',
      build: () {
        when(mockAddToCartUseCase(any)).thenAnswer(
          (_) async => SuccessResponse<void>(null),
        );
        when(mockGetCartUseCase()).thenAnswer(
          (_) async => SuccessResponse<CartEntity>(tCartEntity),
        );
        return cartCubit;
      },
      act: (cubit) => cubit.doEvent(AddToCartEvent(productId: tProductId)),
      expect: () => [
        CartState.initial().copyWith(
          addingProductIds: {tProductId},
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: null,
          ),
        ),
        CartState.initial().copyWith(
          addingProductIds: {},
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tCartEntity,
          ),
        ),
      ],
      verify: (_) {
        verify(mockAddToCartUseCase(any)).called(1);
        verify(mockGetCartUseCase()).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'emits [addingProduct, error] when addToCart fails',
      build: () {
        when(mockAddToCartUseCase(any)).thenAnswer(
          (_) async => ErrorResponse<void>('Product out of stock'),
        );
        return cartCubit;
      },
      act: (cubit) => cubit.doEvent(AddToCartEvent(productId: tProductId)),
      expect: () => [
        CartState.initial().copyWith(
          addingProductIds: {tProductId},
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: null,
          ),
        ),
        CartState.initial().copyWith(
          addingProductIds: {},
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: 'Product out of stock',
            data: null,
          ),
        ),
      ],
      verify: (_) {
        verify(mockAddToCartUseCase(any)).called(1);
        verifyNever(mockGetCartUseCase());
      },
    );
  });

  group('ChangeCartQuantityEvent', () {
    blocTest<CartCubit, CartState>(
      'optimistically updates quantity locally then calls API after timer debounce',
      seed: () => CartState.initial().copyWith(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCartEntity,
        ),
      ),
      build: () {
        when(
          mockUpdateCartQuantityUseCase(
            itemId: anyNamed('itemId'),
            request: anyNamed('request'),
          ),
        ).thenAnswer(
          (_) async => SuccessResponse<CartEntity>(tCartEntity),
        );
        return cartCubit;
      },
      act: (cubit) => cubit.doEvent(
        ChangeCartQuantityEvent(itemId: 'item_1', quantity: 3),
      ),
      wait: Duration(milliseconds: 500),
      verify: (_) {
        verify(
          mockUpdateCartQuantityUseCase(
            itemId: 'item_1',
            request: anyNamed('request'),
          ),
        ).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'triggers removeCartItem when quantity is 0 after debounce',
      seed: () => CartState.initial().copyWith(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCartEntity,
        ),
      ),
      build: () {
        when(mockRemoveCartItemUseCase('item_1')).thenAnswer(
          (_) async => SuccessResponse<CartEntity>(
            CartEntity(
              cartId: 'cart_123',
              items: [],
              totalQuantity: 0,
              lineCount: 0,
              subtotal: 0,
              deliveryFee: 20,
              total: 20,
              hasChanges: false,
            ),
          ),
        );
        return cartCubit;
      },
      act: (cubit) => cubit.doEvent(
        ChangeCartQuantityEvent(itemId: 'item_1', quantity: 0),
      ),
      wait: Duration(milliseconds: 500),
      verify: (_) {
        verify(mockRemoveCartItemUseCase('item_1')).called(1);
      },
    );
  });

  group('RemoveCartItemEvent', () {
    final tEmptyCart = CartEntity(
      cartId: 'cart_123',
      items: [],
      totalQuantity: 0,
      lineCount: 0,
      subtotal: 0,
      deliveryFee: 20.0,
      total: 20.0,
      hasChanges: false,
    );

    blocTest<CartCubit, CartState>(
      'removes item successfully and updates cart',
      seed: () => CartState.initial().copyWith(
        cart: BaseState<CartEntity>(
          isLoading: false,
          errorMessage: null,
          data: tCartEntity,
        ),
      ),
      build: () {
        when(mockRemoveCartItemUseCase('item_1')).thenAnswer(
          (_) async => SuccessResponse<CartEntity>(tEmptyCart),
        );
        return cartCubit;
      },
      act: (cubit) => cubit.doEvent(RemoveCartItemEvent(itemId: 'item_1')),
      expect: () => [
        CartState.initial().copyWith(
          loadingItemIds: {'item_1'},
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tCartEntity,
          ),
        ),
        CartState.initial().copyWith(
          loadingItemIds: {},
          cart: BaseState<CartEntity>(
            isLoading: false,
            errorMessage: null,
            data: tEmptyCart,
          ),
        ),
      ],
      verify: (_) {
        verify(mockRemoveCartItemUseCase('item_1')).called(1);
      },
    );
  });
}