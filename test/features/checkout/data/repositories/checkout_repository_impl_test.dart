import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/data/data_sources/contract/remote/checkout_remote_data_source.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/card_order_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/card_order_response_model.dart';
import 'package:flowrist/features/checkout/data/models/payment_model/delivery_fee_model.dart';
import 'package:flowrist/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/delivery_fee_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'checkout_repository_impl_test.mocks.dart';

@GenerateMocks([
  CheckoutRemoteDataSource,
])
void main() {
    provideDummy<BaseResponse<CardOrderResponseModel>>(
    SuccessResponse<CardOrderResponseModel>(
      CardOrderResponseModel(
        status: true,
        code: 200,
        message: 'Dummy response',
        data: null,
        pagination: null,
        errors: null,
      ),
    ),
  );

  provideDummy<BaseResponse<DeliveryFeeModel>>(
    SuccessResponse<DeliveryFeeModel>(
      DeliveryFeeModel(
        deliveryFee: 0,
        estimatedDeliveryAt: null,
        addressId: '',
        isServiceable: false,
      ),
    ),
  );
  late MockCheckoutRemoteDataSource mockRemoteDataSource;
  late CheckoutRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockCheckoutRemoteDataSource();

    repository = CheckoutRepositoryImpl(
      mockRemoteDataSource,
    );
  });

  group('placeOrder', () {
    final requestEntity = CardOrderRequestEntity(
      cartId: 'cart-123',
      addressId: 'address-123',
      isGift: false,
      paymentMethod: 'Card',
      paymentGateway: 'Stripe',
    );

    test(
      'should return SuccessResponse with CardOrderEntity when remote call succeeds',
      () async {
        // Arrange
        final cardOrderModel = CardOrderModel(
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

        final remoteResponse = CardOrderResponseModel(
          status: true,
          code: 200,
          message: 'Order created successfully',
          data: cardOrderModel,
        );

        when(
          mockRemoteDataSource.placeOrder(any),
        ).thenAnswer(
          (_) async =>
              SuccessResponse<CardOrderResponseModel>(remoteResponse),
        );

        // Act
        final result = await repository.placeOrder(
          requestEntity,
        );

        // Assert
        expect(
          result,
          isA<SuccessResponse>(),
        );

        final successResult =
            result as SuccessResponse;

        expect(
          successResult.data,
          isNotNull,
        );

        expect(
          successResult.data!.orderId,
          'order-123',
        );

        expect(
          successResult.data!.gateway,
          'Stripe',
        );

        expect(
          successResult.data!.amount,
          100.0,
        );

        verify(
          mockRemoteDataSource.placeOrder(any),
        ).called(1);
      },
    );

    test(
      'should return SuccessResponse with null data for COD order',
      () async {
        // Arrange
        final remoteResponse = CardOrderResponseModel(
          status: true,
          code: 200,
          message: 'COD order created successfully',
          data: null,
        );

        when(
          mockRemoteDataSource.placeOrder(any),
        ).thenAnswer(
          (_) async =>
              SuccessResponse<CardOrderResponseModel>(remoteResponse),
        );

        // Act
        final result = await repository.placeOrder(
          requestEntity,
        );

        // Assert
        expect(
          result,
          isA<SuccessResponse>(),
        );

        final successResult =
            result as SuccessResponse;

        expect(
          successResult.data,
          isNull,
        );

        verify(
          mockRemoteDataSource.placeOrder(any),
        ).called(1);
      },
    );

    test(
      'should return ErrorResponse when remote data source fails',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.placeOrder(any),
        ).thenAnswer(
          (_) async =>
              ErrorResponse<CardOrderResponseModel>(
            'Failed to place order',
          ),
        );

        // Act
        final result = await repository.placeOrder(
          requestEntity,
        );

        // Assert
        expect(
          result,
          isA<ErrorResponse>(),
        );

        final errorResult =
            result as ErrorResponse;

        expect(
          errorResult.errorMessage,
          'Failed to place order',
        );

        verify(
          mockRemoteDataSource.placeOrder(any),
        ).called(1);
      },
    );
  });

  group('getDeliveryFee', () {
    const addressId = 'address-123';
    const cartId = 'cart-123';

    test(
      'should return DeliveryFeeEntity when remote call succeeds',
      () async {
        // Arrange
        final deliveryFeeModel = DeliveryFeeModel(
          addressId: addressId,
          deliveryFee: 25.0,
          estimatedDeliveryAt: DateTime(2026, 9, 5),
          isServiceable: true,
        );

        when(
          mockRemoteDataSource.getDeliveryFee(
            addressId: anyNamed('addressId'),
            cartId: anyNamed('cartId'),
          ),
        ).thenAnswer(
          (_) async => SuccessResponse<DeliveryFeeModel>(
            deliveryFeeModel,
          ),
        );

        // Act
        final result = await repository.getDeliveryFee(
          addressId: addressId,
          cartId: cartId,
        );

        // Assert
        expect(
          result,
          isA<SuccessResponse<DeliveryFeeEntity>>(),
        );

        final successResult =
            result as SuccessResponse<DeliveryFeeEntity>;

        expect(
          successResult.data,
          isNotNull,
        );

        expect(
          successResult.data!.addressId,
          addressId,
        );

        expect(
          successResult.data!.deliveryFee,
          25.0,
        );

        expect(
          successResult.data!.isServiceable,
          true,
        );

        verify(
          mockRemoteDataSource.getDeliveryFee(
            addressId: addressId,
            cartId: cartId,
          ),
        ).called(1);
      },
    );

    test(
      'should return ErrorResponse when delivery fee model is null',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getDeliveryFee(
            addressId: anyNamed('addressId'),
            cartId: anyNamed('cartId'),
          ),
        ).thenAnswer(
          (_) async => SuccessResponse<DeliveryFeeModel>(
            null,
          ),
        );

        // Act
        final result = await repository.getDeliveryFee(
          addressId: addressId,
          cartId: cartId,
        );

        // Assert
        expect(
          result,
          isA<ErrorResponse<DeliveryFeeEntity>>(),
        );

        final errorResult =
            result as ErrorResponse<DeliveryFeeEntity>;

        expect(
          errorResult.errorMessage,
          'Invalid delivery fee response',
        );
      },
    );

    test(
      'should return ErrorResponse when remote data source fails',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getDeliveryFee(
            addressId: anyNamed('addressId'),
            cartId: anyNamed('cartId'),
          ),
        ).thenAnswer(
          (_) async => ErrorResponse<DeliveryFeeModel>(
            'Failed to get delivery fee',
          ),
        );

        // Act
        final result = await repository.getDeliveryFee(
          addressId: addressId,
          cartId: cartId,
        );

        // Assert
        expect(
          result,
          isA<ErrorResponse<DeliveryFeeEntity>>(),
        );

        final errorResult =
            result as ErrorResponse<DeliveryFeeEntity>;

        expect(
          errorResult.errorMessage,
          'Failed to get delivery fee',
        );

        verify(
          mockRemoteDataSource.getDeliveryFee(
            addressId: addressId,
            cartId: cartId,
          ),
        ).called(1);
      },
    );
  });
}