import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/remove_cart_item_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/update_cart_quantity_use_case.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';

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

  const tItem1 = CartItemEntity(
    itemId: 'item_1',
    productId: 'prod_1',
    productName: 'Red Roses',
    productImage: 'roses.png',
    unitPrice: 50,
    priceAtAdd: 50,
    quantity: 1,
    availableStock: 10,
  );

  const tItem2 = CartItemEntity(
    itemId: 'item_2',
    productId: 'prod_2',
    productName: 'Tulips',
    productImage: 'tulips.png',
    unitPrice: 30,
    priceAtAdd: 30,
    quantity: 2,
    availableStock: 5,
  );

  final tInitialCart = CartEntity(
    cartId: 'cart_123',
    items: const [tItem1],
    total: 50,
  );

  final tUpdatedCart = CartEntity(
    cartId: 'cart_123',
    items: const [tItem1, tItem2],
    total: 110,
  );

  setUpAll(() {
    provideDummy<BaseResponse<CartEntity>>(
      SuccessResponse<CartEntity>(
        const CartEntity(cartId: '', items: [], total: 0),
      ),
    );
    provideDummy<BaseResponse<void>>(SuccessResponse<void>(null));
  });

  setUp(() {
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

  group('CartCubit - GetCartEvent Tests', () {
    test('initial state should be CartState with default values', () {
      expect(cartCubit.state, equals(const CartState()));
    });

    blocTest<CartCubit, CartState>(
      'emits [loading, success] when getCartUseCase succeeds',
      build: () {
        when(
          mockGetCartUseCase(),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(tInitialCart));
        return cartCubit;
      },
      act: (cubit) => cubit.doIntent(GetCartEvent()),
      expect: () => [
        const CartState(isLoading: true, cart: null, errorMessage: null),
        CartState(isLoading: false, cart: tInitialCart, errorMessage: null),
      ],
      verify: (_) {
        verify(mockGetCartUseCase()).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'emits [loading, error] when getCartUseCase fails',
      build: () {
        when(
          mockGetCartUseCase(),
        ).thenAnswer((_) async => ErrorResponse<CartEntity>('Network Error'));
        return cartCubit;
      },
      act: (cubit) => cubit.doIntent(GetCartEvent()),
      expect: () => [
        const CartState(isLoading: true, cart: null, errorMessage: null),
        const CartState(
          isLoading: false,
          cart: null,
          errorMessage: 'Network Error',
        ),
      ],
      verify: (_) {
        verify(mockGetCartUseCase()).called(1);
      },
    );
  });

  group('CartCubit - AddToCartEvent Tests', () {
    blocTest<CartCubit, CartState>(
      'emits [loadingProductId, updatedCart] when addToCart succeeds and syncs successfully',
      build: () {
        when(
          mockAddToCartUseCase(any),
        ).thenAnswer((_) async => SuccessResponse<void>(null));
        when(
          mockGetCartUseCase(),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(tUpdatedCart));
        return cartCubit;
      },
      seed: () => CartState(cart: tInitialCart),
      act: (cubit) => cubit.doIntent(AddToCartEvent(productId: 'prod_2')),
      expect: () => [
        CartState(
          isLoading: false,
          loadingProductId: 'prod_2',
          cart: tInitialCart,
          errorMessage: null,
        ),
        CartState(
          isLoading: false,
          loadingProductId: null,
          cart: tUpdatedCart,
          errorMessage: null,
        ),
      ],
      verify: (_) {
        verify(mockAddToCartUseCase(any)).called(1);
        verify(mockGetCartUseCase()).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'emits error when addToCart API fails',
      build: () {
        when(
          mockAddToCartUseCase(any),
        ).thenAnswer((_) async => ErrorResponse<void>('Failed to add item'));
        return cartCubit;
      },
      seed: () => CartState(cart: tInitialCart),
      act: (cubit) => cubit.doIntent(AddToCartEvent(productId: 'prod_2')),
      expect: () => [
        CartState(
          isLoading: false,
          loadingProductId: 'prod_2',
          cart: tInitialCart,
          errorMessage: null,
        ),
        CartState(
          isLoading: false,
          loadingProductId: null,
          cart: tInitialCart,
          errorMessage: 'Failed to add item',
        ),
      ],
      verify: (_) {
        verify(mockAddToCartUseCase(any)).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'emits error when addToCart succeeds but sync fails',
      build: () {
        when(
          mockAddToCartUseCase(any),
        ).thenAnswer((_) async => SuccessResponse<void>(null));
        when(
          mockGetCartUseCase(),
        ).thenAnswer((_) async => ErrorResponse<CartEntity>('Sync failed'));
        return cartCubit;
      },
      seed: () => CartState(cart: tInitialCart),
      act: (cubit) => cubit.doIntent(AddToCartEvent(productId: 'prod_2')),
      expect: () => [
        CartState(
          isLoading: false,
          loadingProductId: 'prod_2',
          cart: tInitialCart,
          errorMessage: null,
        ),
        CartState(
          isLoading: false,
          loadingProductId: null,
          cart: tInitialCart,
          errorMessage: 'Sync failed',
        ),
      ],
      verify: (_) {
        verify(mockAddToCartUseCase(any)).called(1);
        verify(mockGetCartUseCase()).called(1);
      },
    );
  });

  group('CartCubit - ChangeCartQuantityEvent Tests (Debounced)', () {
    blocTest<CartCubit, CartState>(
      'instantly updates local state and calls API after debounce on delta = +1',
      build: () {
        final serverUpdatedCart = CartEntity(
          cartId: 'cart_123',
          items: [tItem1.copyWith(quantity: 2)],
          total: 100,
        );
        when(
          mockUpdateCartQuantityUseCase(
            itemId: anyNamed('itemId'),
            request: anyNamed('request'),
          ),
        ).thenAnswer(
          (_) async => SuccessResponse<CartEntity>(serverUpdatedCart),
        );
        return cartCubit;
      },
      seed: () => CartState(cart: tInitialCart),
      act: (cubit) => cubit.doIntent(
        ChangeCartQuantityEvent(productId: 'prod_1', delta: 1),
      ),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        CartState(
          isLoading: false,
          cart: CartEntity(
            cartId: 'cart_123',
            items: [tItem1.copyWith(quantity: 2)],
            total: 100,
          ),
          errorMessage: null,
        ),
        CartState(
          isLoading: false,
          loadingProductId: 'prod_1',
          cart: CartEntity(
            cartId: 'cart_123',
            items: [tItem1.copyWith(quantity: 2)],
            total: 100,
          ),
          errorMessage: null,
        ),
        CartState(
          isLoading: false,
          loadingProductId: null,
          cart: CartEntity(
            cartId: 'cart_123',
            items: [tItem1.copyWith(quantity: 2)],
            total: 100,
          ),
          errorMessage: null,
        ),
      ],
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
      'removes item and calls removeCartItemUseCase after debounce when quantity reaches 0',
      build: () {
        const emptyCart = CartEntity(cartId: 'cart_123', items: [], total: 0);
        when(
          mockRemoveCartItemUseCase(any),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(emptyCart));
        return cartCubit;
      },
      seed: () => CartState(cart: tInitialCart),
      act: (cubit) => cubit.doIntent(
        ChangeCartQuantityEvent(productId: 'prod_1', delta: -1),
      ),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const CartState(
          isLoading: false,
          cart: CartEntity(cartId: 'cart_123', items: [], total: 0),
          errorMessage: null,
        ),
        const CartState(
          isLoading: false,
          loadingProductId: 'prod_1',
          cart: CartEntity(cartId: 'cart_123', items: [], total: 0),
          errorMessage: null,
        ),
        const CartState(
          isLoading: false,
          loadingProductId: null,
          cart: CartEntity(cartId: 'cart_123', items: [], total: 0),
          errorMessage: null,
        ),
      ],
      verify: (_) {
        verify(mockRemoveCartItemUseCase('item_1')).called(1);
      },
    );
  });

  group('CartCubit - RemoveCartItemEvent Tests', () {
    blocTest<CartCubit, CartState>(
      'emits [loadingProductId, successCart] when removeCartItemUseCase succeeds',
      build: () {
        const emptyCart = CartEntity(cartId: 'cart_123', items: [], total: 0);
        when(
          mockRemoveCartItemUseCase('item_1'),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(emptyCart));
        return cartCubit;
      },
      seed: () => CartState(cart: tInitialCart),
      act: (cubit) => cubit.doIntent(RemoveCartItemEvent(itemId: 'item_1')),
      expect: () => [
        CartState(
          isLoading: false,
          loadingProductId: 'prod_1',
          cart: tInitialCart,
          errorMessage: null,
        ),
        const CartState(
          isLoading: false,
          loadingProductId: null,
          cart: CartEntity(cartId: 'cart_123', items: [], total: 0),
          errorMessage: null,
        ),
      ],
      verify: (_) {
        verify(mockRemoveCartItemUseCase('item_1')).called(1);
      },
    );
  });
}
