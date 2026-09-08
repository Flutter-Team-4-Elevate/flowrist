import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/features/home/cart/data/client/cart_api_client.dart';
import 'package:flowrist/features/home/cart/data/data_sources/impl/cart_remote_data_source_impl.dart';
import 'package:flowrist/features/home/cart/data/models/request/add_to_cart_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/request/update_cart_item_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/response/cart_response_dto.dart';

@GenerateMocks([CartApiClient])
import 'cart_remote_data_source_impl_test.mocks.dart';

void main() {
  late MockCartApiClient mockApiClient;
  late CartRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockCartApiClient();
    dataSource = CartRemoteDataSourceImpl(mockApiClient);
  });

  const tCartResponseDto = CartResponseDto(
    status: true,
    code: 200,
    message: 'Success',
    data: CartDataDto(cartId: 'cart_123', totalQuantity: 2, total: 100),
  );

  group('CartRemoteDataSourceImpl Unit Tests', () {
    test(
      'getCart should call apiClient.getCart and return CartResponseDto',
      () async {
        when(mockApiClient.getCart()).thenAnswer((_) async => tCartResponseDto);

        final result = await dataSource.getCart();

        expect(result, equals(tCartResponseDto));
        verify(mockApiClient.getCart()).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('addToCart should forward request to apiClient.addToCart', () async {
      const tRequest = AddToCartRequestDto(productId: 'prod_1', quantity: 1);
      when(
        mockApiClient.addToCart(tRequest),
      ).thenAnswer((_) async => {'status': 'success'});

      final result = await dataSource.addToCart(tRequest);

      expect(result, equals({'status': 'success'}));
      verify(mockApiClient.addToCart(tRequest)).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test(
      'updateCartItemQuantity should forward itemId and request to apiClient',
      () async {
        const tRequest = UpdateCartItemRequestDto(quantity: 3);
        when(
          mockApiClient.updateCartItemQuantity('item_1', tRequest),
        ).thenAnswer((_) async => tCartResponseDto);

        final result = await dataSource.updateCartItemQuantity(
          itemId: 'item_1',
          request: tRequest,
        );

        expect(result, equals(tCartResponseDto));
        verify(
          mockApiClient.updateCartItemQuantity('item_1', tRequest),
        ).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'removeCartItem should forward itemId to apiClient and return CartResponseDto',
      () async {
        when(
          mockApiClient.removeCartItem('item_1'),
        ).thenAnswer((_) async => tCartResponseDto);

        final result = await dataSource.removeCartItem('item_1');

        expect(result, equals(tCartResponseDto));
        verify(mockApiClient.removeCartItem('item_1')).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );
  });
}
