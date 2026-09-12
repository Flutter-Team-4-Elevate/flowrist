import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/repositories/cart_repository.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/get_cart_use_case.dart';

@GenerateMocks([CartRepository])
import 'get_cart_use_case_test.mocks.dart';

void main() {
  late MockCartRepository mockRepository;
  late GetCartUseCase useCase;

  const tCart = CartEntity(
    cartId: 'cart_123',
    items: [],
    totalQuantity: 0,
    lineCount: 0,
    subtotal: 0,
    deliveryFee: 50,
    total: 50,
    hasChanges: false,
  );

  setUpAll(() {
    provideDummy<BaseResponse<CartEntity>>(
      SuccessResponse<CartEntity>(tCart),
    );
  });

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = GetCartUseCase(mockRepository);
  });

  group('GetCartUseCase Unit Tests', () {
    test(
      'should return BaseResponse<CartEntity> from the repository',
      () async {
        // Arrange
        when(
          mockRepository.getCart(),
        ).thenAnswer(
          (_) async => SuccessResponse<CartEntity>(tCart),
        );

        // Act
        final result = await useCase();

        // Assert
        expect(result, isA<SuccessResponse<CartEntity>>());

        final data = (result as SuccessResponse<CartEntity>).data;

        expect(data, isNotNull);
        expect(data!.cartId, equals('cart_123'));
        expect(data.totalQuantity, equals(0));
        expect(data.lineCount, equals(0));
        expect(data.subtotal, equals(0));
        expect(data.deliveryFee, equals(50));
        expect(data.total, equals(50));
        expect(data.hasChanges, isFalse);

        verify(mockRepository.getCart()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
