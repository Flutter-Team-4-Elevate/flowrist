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

  const tCart = CartEntity(cartId: 'cart_123', items: [], total: 0);

  setUpAll(() {
    provideDummy<BaseResponse<CartEntity>>(SuccessResponse<CartEntity>(tCart));
  });

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = GetCartUseCase(mockRepository);
  });

  group('GetCartUseCase Unit Tests', () {
    test(
      'should return BaseResponse<CartEntity> from the repository',
      () async {
        when(
          mockRepository.getCart(),
        ).thenAnswer((_) async => SuccessResponse<CartEntity>(tCart));

        final result = await useCase();

        expect(result, isA<SuccessResponse<CartEntity>>());
        final data = (result as SuccessResponse<CartEntity>).data;
        expect(data?.cartId, equals('cart_123'));
        verify(mockRepository.getCart()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
