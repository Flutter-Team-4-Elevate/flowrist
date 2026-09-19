import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/cart/data/models/request/add_to_cart_request_dto.dart';
import 'package:flowrist/features/home/cart/domain/repositories/cart_repository.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/add_to_cart_use_case.dart';

@GenerateMocks([CartRepository])
import 'add_to_cart_use_case_test.mocks.dart';

void main() {
  late MockCartRepository mockRepository;
  late AddToCartUseCase useCase;

  setUpAll(() {
    provideDummy<BaseResponse<void>>(SuccessResponse<void>(null));
  });

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = AddToCartUseCase(mockRepository);
  });

  const tRequest = AddToCartRequestDto(productId: 'prod_1', quantity: 1);

  group('AddToCartUseCase Unit Tests', () {
    test(
      'should forward request to repository and return SuccessResponse<void>',
      () async {
        when(
          mockRepository.addToCart(tRequest),
        ).thenAnswer((_) async => SuccessResponse<void>(null));

        final result = await useCase(tRequest);

        expect(result, isA<SuccessResponse<void>>());
        verify(mockRepository.addToCart(tRequest)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
