import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_details_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/use_cases/get_order_details_use_case.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/use_cases/get_orders_use_case.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_cubit.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_events.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_state.dart';

import 'orders_cubit_test.mocks.dart';

@GenerateMocks([GetOrdersUseCase, GetOrderDetailsUseCase])
void main() {
  late MockGetOrdersUseCase mockGetOrdersUseCase;
  late MockGetOrderDetailsUseCase mockGetOrderDetailsUseCase;
  late OrdersCubit ordersCubit;

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

  const tOrderDetails = OrderDetailsEntity(
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
    provideDummy<BaseResponse<List<OrderEntity>>>(
      SuccessResponse<List<OrderEntity>>([]),
    );
    provideDummy<BaseResponse<OrderDetailsEntity>>(
      SuccessResponse<OrderDetailsEntity>(tOrderDetails),
    );

    mockGetOrdersUseCase = MockGetOrdersUseCase();
    mockGetOrderDetailsUseCase = MockGetOrderDetailsUseCase();
    ordersCubit = OrdersCubit(mockGetOrdersUseCase, mockGetOrderDetailsUseCase);
  });

  tearDown(() {
    ordersCubit.close();
  });

  test('initial state should have correct default values', () {
    expect(ordersCubit.state, equals(const OrdersState()));
  });

  group('LoadOrdersEvent', () {
    blocTest<OrdersCubit, OrdersState>(
      'emits [OrdersStatus.loading, OrdersStatus.success] when GetOrdersUseCase succeeds',
      build: () {
        when(
          mockGetOrdersUseCase.call(page: 1, pageSize: 10),
        ).thenAnswer((_) async => SuccessResponse<List<OrderEntity>>(tOrders));
        return ordersCubit;
      },
      act: (cubit) =>
          cubit.doEvent(const LoadOrdersEvent(page: 1, pageSize: 10)),
      expect: () => [
        const OrdersState(status: OrdersStatus.loading),
        const OrdersState(status: OrdersStatus.success, allOrders: tOrders),
      ],
      verify: (_) {
        verify(mockGetOrdersUseCase.call(page: 1, pageSize: 10)).called(1);
      },
    );

    blocTest<OrdersCubit, OrdersState>(
      'emits [OrdersStatus.loading, OrdersStatus.failure] when GetOrdersUseCase fails',
      build: () {
        when(mockGetOrdersUseCase.call(page: 1, pageSize: 10)).thenAnswer(
          (_) async => ErrorResponse<List<OrderEntity>>('Network error'),
        );
        return ordersCubit;
      },
      act: (cubit) =>
          cubit.doEvent(const LoadOrdersEvent(page: 1, pageSize: 10)),
      expect: () => [
        const OrdersState(status: OrdersStatus.loading),
        const OrdersState(
          status: OrdersStatus.failure,
          errorMessage: 'Network error',
        ),
      ],
    );
  });

  group('LoadOrderDetailsEvent', () {
    blocTest<OrdersCubit, OrdersState>(
      'emits [isLoadingDetails: true, isLoadingDetails: false with details] on success',
      build: () {
        when(mockGetOrderDetailsUseCase.call(orderId: '1')).thenAnswer(
          (_) async => SuccessResponse<OrderDetailsEntity>(tOrderDetails),
        );
        return ordersCubit;
      },
      act: (cubit) => cubit.doEvent(const LoadOrderDetailsEvent('1')),
      expect: () => [
        const OrdersState(isLoadingDetails: true),
        const OrdersState(
          isLoadingDetails: false,
          selectedOrderDetails: tOrderDetails,
        ),
      ],
      verify: (_) {
        verify(mockGetOrderDetailsUseCase.call(orderId: '1')).called(1);
      },
    );

    blocTest<OrdersCubit, OrdersState>(
      'emits [isLoadingDetails: true, isLoadingDetails: false with errorMessage] on failure',
      build: () {
        when(mockGetOrderDetailsUseCase.call(orderId: '1')).thenAnswer(
          (_) async => ErrorResponse<OrderDetailsEntity>('Order not found'),
        );
        return ordersCubit;
      },
      act: (cubit) => cubit.doEvent(const LoadOrderDetailsEvent('1')),
      expect: () => [
        const OrdersState(isLoadingDetails: true),
        const OrdersState(
          isLoadingDetails: false,
          errorMessage: 'Order not found',
        ),
      ],
    );
  });
}
