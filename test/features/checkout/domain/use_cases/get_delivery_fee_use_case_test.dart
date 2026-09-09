import 'package:flutter_test/flutter_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/delivery_fee_entity.dart';
import 'package:flowrist/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:flowrist/features/checkout/domain/use_cases/get_delivery_fee_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_delivery_fee_use_case_test.mocks.dart';

@GenerateMocks([
  CheckoutRepository,
])
void main() {
  late MockCheckoutRepository mockRepository;
  late GetDeliveryFeeUseCase useCase;

  setUpAll(() {
    provideDummy<BaseResponse<DeliveryFeeEntity>>(
      SuccessResponse<DeliveryFeeEntity>(
        DeliveryFeeEntity(
          addressId: '',
          deliveryFee: 0,
          estimatedDeliveryAt: null,
          isServiceable: false,
        ),
      ),
    );
  });

  setUp(() {
    mockRepository = MockCheckoutRepository();

    useCase = GetDeliveryFeeUseCase(
      mockRepository,
    );
  });

  group('GetDeliveryFeeUseCase', () {
    const addressId = 'address-123';
    const cartId = 'cart-123';

    test(
      'should return DeliveryFeeEntity when repository succeeds',
      () async {
        // Arrange
        final deliveryFee = DeliveryFeeEntity(
          addressId: addressId,
          deliveryFee: 25.0,
          estimatedDeliveryAt: DateTime(2026, 9, 5),
          isServiceable: true,
        );

        when(
          mockRepository.getDeliveryFee(
            addressId: addressId,
            cartId: cartId,
          ),
        ).thenAnswer(
          (_) async => SuccessResponse<DeliveryFeeEntity>(
            deliveryFee,
          ),
        );

        // Act
        final result = await useCase(
          addressId: addressId,
          cartId: cartId,
        );

        // Assert
        expect(
          result,
          isA<SuccessResponse<DeliveryFeeEntity>>(),
        );

        final success =
            result as SuccessResponse<DeliveryFeeEntity>;

        expect(success.data, isNotNull);
        expect(success.data?.addressId, addressId);
        expect(success.data?.deliveryFee, 25.0);
        expect(success.data?.isServiceable, true);

        verify(
          mockRepository.getDeliveryFee(
            addressId: addressId,
            cartId: cartId,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return ErrorResponse when repository fails',
      () async {
        // Arrange
        when(
          mockRepository.getDeliveryFee(
            addressId: addressId,
            cartId: cartId,
          ),
        ).thenAnswer(
          (_) async => ErrorResponse<DeliveryFeeEntity>(
            'Failed to get delivery fee',
          ),
        );

        // Act
        final result = await useCase(
          addressId: addressId,
          cartId: cartId,
        );

        // Assert
        expect(
          result,
          isA<ErrorResponse<DeliveryFeeEntity>>(),
        );

        final error =
            result as ErrorResponse<DeliveryFeeEntity>;

        expect(
          error.errorMessage,
          'Failed to get delivery fee',
        );

        verify(
          mockRepository.getDeliveryFee(
            addressId: addressId,
            cartId: cartId,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}