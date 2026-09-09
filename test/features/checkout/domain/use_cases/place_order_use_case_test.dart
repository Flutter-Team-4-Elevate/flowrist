import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';
import 'package:flowrist/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:flowrist/features/checkout/domain/use_cases/place_order_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'place_order_use_case_test.mocks.dart';

@GenerateMocks([
  CheckoutRepository,
])
void main() {
  late MockCheckoutRepository mockCheckoutRepository;
  late PlaceOrderUseCase placeOrderUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<CardOrderEntity?>>(
      SuccessResponse<CardOrderEntity?>(null),
    );
  });

  setUp(() {
    mockCheckoutRepository = MockCheckoutRepository();

    placeOrderUseCase = PlaceOrderUseCase(
      mockCheckoutRepository,
    );
  });

  group('PlaceOrderUseCase', () {
    final request = CardOrderRequestEntity(
      cartId: 'cart_123',
      addressId: 'address_123',
      isGift: false,
      giftRecipient: null,
      paymentMethod: 'Cod',
      paymentGateway: null,
    );

    test(
      'should return CardOrderEntity when repository returns success',
      () async {
        // Arrange
        final order = CardOrderEntity(
          orderId: 'order_123',
          status: 'pending',
          gateway: 'Stripe',
          sessionId: 'session_123',
          sessionUrl: 'https://example.com/payment',
          successUrl: 'https://example.com/success',
          cancelUrl: 'https://example.com/cancel',
          expiresAt: DateTime(2026, 9, 5),
          amount: 500,
          currency: 'EGP',
          estimatedDeliveryAt: DateTime(2026, 9, 6),
        );

        when(
          mockCheckoutRepository.placeOrder(request),
        ).thenAnswer(
          (_) async => SuccessResponse<CardOrderEntity?>(
            order,
          ),
        );

        // Act
        final result = await placeOrderUseCase(request);

        // Assert
        expect(
          result,
          isA<SuccessResponse<CardOrderEntity?>>(),
        );

        final success = result as SuccessResponse<CardOrderEntity?>;

        expect(success.data, isNotNull);
        expect(success.data?.orderId, 'order_123');

        verify(
          mockCheckoutRepository.placeOrder(request),
        ).called(1);

        verifyNoMoreInteractions(mockCheckoutRepository);
      },
    );

    test(
      'should return success with null data for COD order',
      () async {
        // Arrange
        final codRequest = CardOrderRequestEntity(
          cartId: 'cart_123',
          addressId: 'address_123',
          isGift: false,
          giftRecipient: null,
          paymentMethod: 'Cod',
          paymentGateway: null,
        );

        when(
          mockCheckoutRepository.placeOrder(codRequest),
        ).thenAnswer(
          (_) async => SuccessResponse<CardOrderEntity?>(
            null,
          ),
        );

        // Act
        final result = await placeOrderUseCase(codRequest);

        // Assert
        expect(
          result,
          isA<SuccessResponse<CardOrderEntity?>>(),
        );

        final success = result as SuccessResponse<CardOrderEntity?>;

        expect(success.data, isNull);

        verify(
          mockCheckoutRepository.placeOrder(codRequest),
        ).called(1);
      },
    );

    test(
      'should return ErrorResponse when repository fails',
      () async {
        // Arrange
        when(
          mockCheckoutRepository.placeOrder(request),
        ).thenAnswer(
          (_) async => ErrorResponse<CardOrderEntity?>(
            'Failed to place order',
          ),
        );

        // Act
        final result = await placeOrderUseCase(request);

        // Assert
        expect(
          result,
          isA<ErrorResponse<CardOrderEntity?>>(),
        );

        final error = result as ErrorResponse<CardOrderEntity?>;

        expect(
          error.errorMessage,
          'Failed to place order',
        );

        verify(
          mockCheckoutRepository.placeOrder(request),
        ).called(1);

        verifyNoMoreInteractions(mockCheckoutRepository);
      },
    );
  });
}