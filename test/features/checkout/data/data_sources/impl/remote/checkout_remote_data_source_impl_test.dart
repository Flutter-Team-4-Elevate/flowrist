import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/data/client/checkout_api_client.dart';
import 'package:flowrist/features/checkout/data/data_sources/impl/remote/checkout_remote_data_source_impl.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/card_order_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/card_order_request_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/card_order_response_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/delivery_fee_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/delivery_fee_response_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'checkout_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([CheckoutApiClient])
void main() {
  late MockCheckoutApiClient mockApiClient;
  late CheckoutRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockCheckoutApiClient();

    dataSource = CheckoutRemoteDataSourceImpl(mockApiClient);
  });

  group('placeOrder', () {
    final request = CardOrderRequestModel(
      cartId: 'cart-123',
      addressId: 'address-123',
      isGift: false,
      paymentMethod: 'Card',
      paymentGateway: 'Stripe',
    );

    final cardOrder = CardOrderModel(
      orderId: 'order-123',
      status: 'Pending',
      gateway: 'Stripe',
      sessionId: 'session-123',
      sessionUrl: 'https://checkout.stripe.com/session',
      successUrl: 'https://example.com/success',
      cancelUrl: 'https://example.com/cancel',
      expiresAt: DateTime(2026, 12, 31),
      amount: 100.0,
      currency: 'EGP',
      estimatedDeliveryAt: DateTime(2027, 1, 2),
    );

    final response = CardOrderResponseModel(
      status: true,
      code: 200,
      message: 'Order created successfully',
      data: cardOrder,
    );

    test('should return SuccessResponse when API call succeeds', () async {
      // Arrange
      when(
        mockApiClient.placeOrder(any, any),
      ).thenAnswer((_) async => response);

      // Act
      final result = await dataSource.placeOrder(request);

      // Assert
      expect(result, isA<SuccessResponse<CardOrderResponseModel>>());

      final successResult = result as SuccessResponse<CardOrderResponseModel>;

      expect(successResult.data, response);

      verify(mockApiClient.placeOrder(any, any)).called(1);

      verifyNoMoreInteractions(mockApiClient);
    });

    test('should return ErrorResponse when API throws DioException', () async {
      // Arrange
      when(mockApiClient.placeOrder(any, any)).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/orders')),
      );

      // Act
      final result = await dataSource.placeOrder(request);

      // Assert
      expect(result, isA<ErrorResponse<CardOrderResponseModel>>());

      verify(mockApiClient.placeOrder(any, any)).called(1);
    });
  });

  group('getDeliveryFee', () {
    const addressId = 'address-123';
    const cartId = 'cart-123';

    test('should return SuccessResponse when delivery fee exists', () async {
      // Arrange

      final deliveryFee = DeliveryFeeModel(
        addressId: 'address-123',
        deliveryFee: 25.0,
        estimatedDeliveryAt: DateTime(2026, 9, 5),
        isServiceable: true,
      );

      final response = DeliveryFeeResponseModel(
        status: true,
        code: 200,
        message: 'Delivery fee retrieved successfully',
        data: deliveryFee,
      );

      when(
        mockApiClient.getDeliveryFee(
          addressId: anyNamed('addressId'),
          cartId: anyNamed('cartId'),
        ),
      ).thenAnswer((_) async => response);

      // Act
      final result = await dataSource.getDeliveryFee(
        addressId: addressId,
        cartId: cartId,
      );

      // Assert
      expect(result, isA<SuccessResponse<DeliveryFeeModel>>());

      final successResult = result as SuccessResponse<DeliveryFeeModel>;

      expect(successResult.data, deliveryFee);

      verify(
        mockApiClient.getDeliveryFee(addressId: addressId, cartId: cartId),
      ).called(1);
    });

    test('should return ErrorResponse when response data is null', () async {
      // Arrange

      final response = DeliveryFeeResponseModel(
        status: false,
        code: 400,
        message: 'Delivery fee not found',
        data: null,
      );

      when(
        mockApiClient.getDeliveryFee(
          addressId: anyNamed('addressId'),
          cartId: anyNamed('cartId'),
        ),
      ).thenAnswer((_) async => response);

      // Act
      final result = await dataSource.getDeliveryFee(
        addressId: addressId,
        cartId: cartId,
      );

      // Assert
      expect(result, isA<ErrorResponse<DeliveryFeeModel>>());

      final errorResult = result as ErrorResponse<DeliveryFeeModel>;

      expect(errorResult.errorMessage, 'Delivery fee not found');

      verify(
        mockApiClient.getDeliveryFee(addressId: addressId, cartId: cartId),
      ).called(1);
    });

    test('should return ErrorResponse when API throws an exception', () async {
      // Arrange

      when(
        mockApiClient.getDeliveryFee(
          addressId: anyNamed('addressId'),
          cartId: anyNamed('cartId'),
        ),
      ).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/delivery-fee')),
      );

      // Act
      final result = await dataSource.getDeliveryFee(
        addressId: addressId,
        cartId: cartId,
      );

      // Assert
      expect(result, isA<ErrorResponse<DeliveryFeeModel>>());

      verify(
        mockApiClient.getDeliveryFee(addressId: addressId, cartId: cartId),
      ).called(1);
    });
  });
}
