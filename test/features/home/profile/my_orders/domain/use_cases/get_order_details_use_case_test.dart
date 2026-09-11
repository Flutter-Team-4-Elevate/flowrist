import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_details_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/repositories/orders_repository.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/use_cases/get_order_details_use_case.dart';

import 'get_order_details_use_case_test.mocks.dart';

@GenerateMocks([OrdersRepository])
void main() {
  late MockOrdersRepository mockRepository;
  late GetOrderDetailsUseCase useCase;

  const tDetails = OrderDetailsEntity(
    id: '1',
    orderNumber: 'ORD-1',
    status: 'Delivered',
    paymentMethod: 'Cash',
    paymentStatus: 'Paid',
    subtotal: 100,
    deliveryFee: 20,
    total: 120,
  );

  setUp(() {
    provideDummy<BaseResponse<OrderDetailsEntity>>(
      SuccessResponse<OrderDetailsEntity>(tDetails),
    );

    mockRepository = MockOrdersRepository();
    useCase = GetOrderDetailsUseCase(mockRepository);
  });

  test(
    'should call repository.getOrderDetails with correct orderId and return response',
    () async {
      when(
        mockRepository.getOrderDetails(orderId: '1'),
      ).thenAnswer((_) async => SuccessResponse<OrderDetailsEntity>(tDetails));

      final result = await useCase.call(orderId: '1');

      expect(result, isA<SuccessResponse<OrderDetailsEntity>>());
      expect((result as SuccessResponse).data, equals(tDetails));
      verify(mockRepository.getOrderDetails(orderId: '1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
