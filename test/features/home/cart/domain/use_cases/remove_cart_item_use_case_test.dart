import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/repositories/cart_repository.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/remove_cart_item_use_case.dart';

@GenerateMocks([CartRepository])
import 'remove_cart_item_use_case_test.mocks.dart';

void main() {
  late MockCartRepository mockRepository;
  late RemoveCartItemUseCase useCase;

  const tCart = CartEntity(cartId: 'cart_123', items: [], total: 0);

  setUpAll(() {
    provideDummy<BaseResponse<CartEntity>>(SuccessResponse<CartEntity>(tCart));
  });

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = RemoveCartItemUseCase(mockRepository);
  });

  group('RemoveCartItemUseCase Unit Tests', () {
    test(
      'should forward itemId to repository and return updated CartEntity',
      () async {
        when(
          mockRepository.removeCartItem('item_1'),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(tCart));

        final result = await useCase('item_1');

        expect(result, isA<SuccessResponse<CartEntity>>());
        final data = (result as SuccessResponse<CartEntity>).data;
        expect(data?.cartId, equals('cart_123'));
        verify(mockRepository.removeCartItem('item_1')).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
