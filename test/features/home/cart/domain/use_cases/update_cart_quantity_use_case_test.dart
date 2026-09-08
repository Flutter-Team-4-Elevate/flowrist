import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/cart/data/models/request/update_cart_item_request_dto.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/repositories/cart_repository.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/update_cart_quantity_use_case.dart';

@GenerateMocks([CartRepository])
import 'update_cart_quantity_use_case_test.mocks.dart';

void main() {
  late MockCartRepository mockRepository;
  late UpdateCartQuantityUseCase useCase;

  const tRequest = UpdateCartItemRequestDto(quantity: 4);
  const tCart = CartEntity(cartId: 'cart_123', items: [], total: 200);

  setUpAll(() {
    provideDummy<BaseResponse<CartEntity>>(SuccessResponse<CartEntity>(tCart));
  });

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = UpdateCartQuantityUseCase(mockRepository);
  });

  group('UpdateCartQuantityUseCase Unit Tests', () {
    test(
      'should forward itemId and request to repository and return updated CartEntity',
      () async {
        when(
          mockRepository.updateCartItemQuantity(
            itemId: 'item_1',
            request: tRequest,
          ),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(tCart));

        final result = await useCase(itemId: 'item_1', request: tRequest);

        expect(result, isA<SuccessResponse<CartEntity>>());
        final data = (result as SuccessResponse<CartEntity>).data;
        expect(data?.total, equals(200));
        verify(
          mockRepository.updateCartItemQuantity(
            itemId: 'item_1',
            request: tRequest,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
