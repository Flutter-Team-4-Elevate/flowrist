import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/cart/data/data_sources/contract/cart_remote_data_source.dart';
import 'package:flowrist/features/home/cart/data/models/request/add_to_cart_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/request/update_cart_item_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/response/cart_response_dto.dart';
import 'package:flowrist/features/home/cart/data/repositories/cart_repository_impl.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';

@GenerateMocks([CartRemoteDataSource])
import 'cart_repository_impl_test.mocks.dart';

void main() {
  late MockCartRemoteDataSource mockRemoteDataSource;
  late CartRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockCartRemoteDataSource();
    repository = CartRepositoryImpl(mockRemoteDataSource);
  });

  const tCartResponseDto = CartResponseDto(
    message: 'Success',
    data: CartDataDto(
      cartId: 'cart_123',
      total: 100,
      items: [
        CartItemDto(
          itemId: 'item_1',
          productId: 'prod_1',
          productName: 'Red Roses',
          productImage: 'roses.png',
          unitPrice: 50,
          priceAtAdd: 50,
          quantity: 2,
          availableStock: 10,
        ),
      ],
    ),
  );

  group('CartRepositoryImpl - getCart Tests', () {
    test(
      'should return SuccessResponse<CartEntity> when remote call is successful',
      () async {
        when(
          mockRemoteDataSource.getCart(),
        ).thenAnswer((_) async => tCartResponseDto);

        final result = await repository.getCart();

        expect(result, isA<SuccessResponse<CartEntity>>());
        final entity = (result as SuccessResponse<CartEntity>).data;
        expect(entity?.cartId, equals('cart_123'));
        expect(entity?.items.length, equals(1));
        verify(mockRemoteDataSource.getCart()).called(1);
      },
    );

    test(
      'should return FailureResponse when remote call throws an exception',
      () async {
        when(
          mockRemoteDataSource.getCart(),
        ).thenThrow(Exception('Network error'));

        final result = await repository.getCart();

        expect(result, isNot(isA<SuccessResponse<CartEntity>>()));
        verify(mockRemoteDataSource.getCart()).called(1);
      },
    );
  });

  group('CartRepositoryImpl - addToCart Tests', () {
    const tAddRequest = AddToCartRequestDto(productId: 'prod_1', quantity: 1);

    test(
      'should return SuccessResponse<void> when remote call is successful',
      () async {
        when(
          mockRemoteDataSource.addToCart(tAddRequest),
        ).thenAnswer((_) async => {});

        final result = await repository.addToCart(tAddRequest);

        expect(result, isA<SuccessResponse<void>>());
        verify(mockRemoteDataSource.addToCart(tAddRequest)).called(1);
      },
    );

    test(
      'should return FailureResponse when remote call throws an exception',
      () async {
        when(
          mockRemoteDataSource.addToCart(tAddRequest),
        ).thenThrow(Exception('Failed to add'));

        final result = await repository.addToCart(tAddRequest);

        expect(result, isNot(isA<SuccessResponse<void>>()));
        verify(mockRemoteDataSource.addToCart(tAddRequest)).called(1);
      },
    );
  });

  group('CartRepositoryImpl - updateCartItemQuantity Tests', () {
    const tUpdateRequest = UpdateCartItemRequestDto(quantity: 3);

    test(
      'should return SuccessResponse<CartEntity> when remote call is successful',
      () async {
        when(
          mockRemoteDataSource.updateCartItemQuantity(
            itemId: 'item_1',
            request: tUpdateRequest,
          ),
        ).thenAnswer((_) async => tCartResponseDto);

        final result = await repository.updateCartItemQuantity(
          itemId: 'item_1',
          request: tUpdateRequest,
        );

        expect(result, isA<SuccessResponse<CartEntity>>());
        final entity = (result as SuccessResponse<CartEntity>).data;
        expect(entity?.cartId, equals('cart_123'));
        verify(
          mockRemoteDataSource.updateCartItemQuantity(
            itemId: 'item_1',
            request: tUpdateRequest,
          ),
        ).called(1);
      },
    );

    test(
      'should return FailureResponse when remote call throws an exception',
      () async {
        when(
          mockRemoteDataSource.updateCartItemQuantity(
            itemId: 'item_1',
            request: tUpdateRequest,
          ),
        ).thenThrow(Exception('Update error'));

        final result = await repository.updateCartItemQuantity(
          itemId: 'item_1',
          request: tUpdateRequest,
        );

        expect(result, isNot(isA<SuccessResponse<CartEntity>>()));
        verify(
          mockRemoteDataSource.updateCartItemQuantity(
            itemId: 'item_1',
            request: tUpdateRequest,
          ),
        ).called(1);
      },
    );
  });

  group('CartRepositoryImpl - removeCartItem Tests', () {
    test(
      'should return SuccessResponse<CartEntity> when remote call is successful',
      () async {
        when(
          mockRemoteDataSource.removeCartItem('item_1'),
        ).thenAnswer((_) async => tCartResponseDto);

        final result = await repository.removeCartItem('item_1');

        expect(result, isA<SuccessResponse<CartEntity>>());
        final entity = (result as SuccessResponse<CartEntity>).data;
        expect(entity?.cartId, equals('cart_123'));
        verify(mockRemoteDataSource.removeCartItem('item_1')).called(1);
      },
    );

    test(
      'should return FailureResponse when remote call throws an exception',
      () async {
        when(
          mockRemoteDataSource.removeCartItem('item_1'),
        ).thenThrow(Exception('Remove error'));

        final result = await repository.removeCartItem('item_1');

        expect(result, isNot(isA<SuccessResponse<CartEntity>>()));
        verify(mockRemoteDataSource.removeCartItem('item_1')).called(1);
      },
    );
  });
}
