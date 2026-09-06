import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/repositories/orders_repository.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/use_cases/get_orders_use_case.dart';

import 'get_orders_use_case_test.mocks.dart';

@GenerateMocks([OrdersRepository])
void main() {
  late MockOrdersRepository mockRepository;
  late GetOrdersUseCase useCase;

  const tOrders = [
    OrderEntity(
      id: '1',
      orderNumber: 'ORD-1',
      itemCount: 1,
      rawStatus: 'Delivered',
      displayStatus: OrderDisplayStatus.completed,
      total: 100,
      paymentStatus: 'Paid',
    ),
  ];

  setUp(() {
    provideDummy<BaseResponse<List<OrderEntity>>>(
      SuccessResponse<List<OrderEntity>>([]),
    );

    mockRepository = MockOrdersRepository();
    useCase = GetOrdersUseCase(mockRepository);
  });

  test(
    'should call repository.getOrders with correct params and return response',
    () async {
      when(
        mockRepository.getOrders(page: 1, pageSize: 10),
      ).thenAnswer((_) async => SuccessResponse<List<OrderEntity>>(tOrders));

      final result = await useCase.call(page: 1, pageSize: 10);

      expect(result, isA<SuccessResponse<List<OrderEntity>>>());
      expect((result as SuccessResponse).data, equals(tOrders));
      verify(mockRepository.getOrders(page: 1, pageSize: 10)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
