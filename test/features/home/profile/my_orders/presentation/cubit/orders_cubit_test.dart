import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_details_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/use_cases/get_order_details_use_case.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/use_cases/get_orders_use_case.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_cubit.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_events.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

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
      'emits [orders.isLoading: true, orders.success with data] when GetOrdersUseCase succeeds',
      build: () {
        when(
          mockGetOrdersUseCase.call(page: 1, pageSize: 10),
        ).thenAnswer((_) async => SuccessResponse<List<OrderEntity>>(tOrders));
        return ordersCubit;
      },
      act: (cubit) =>
          cubit.doEvent(const LoadOrdersEvent(page: 1, pageSize: 10)),
      expect: () => [
        const OrdersState(
          orders: BaseState(isLoading: true, errorMessage: null, data: null),
          currentPage: 1,
          hasNextPage: true,
        ),
        const OrdersState(
          orders: BaseState(
            isLoading: false,
            errorMessage: null,
            data: tOrders,
          ),
          currentPage: 1,
          hasNextPage: false,
        ),
      ],
      verify: (_) {
        verify(mockGetOrdersUseCase.call(page: 1, pageSize: 10)).called(1);
      },
    );

    blocTest<OrdersCubit, OrdersState>(
      'emits [orders.isLoading: true, orders.error with message] when GetOrdersUseCase fails',
      build: () {
        when(mockGetOrdersUseCase.call(page: 1, pageSize: 10)).thenAnswer(
          (_) async => ErrorResponse<List<OrderEntity>>('Network error'),
        );
        return ordersCubit;
      },
      act: (cubit) =>
          cubit.doEvent(const LoadOrdersEvent(page: 1, pageSize: 10)),
      expect: () => [
        const OrdersState(
          orders: BaseState(isLoading: true, errorMessage: null, data: null),
          currentPage: 1,
          hasNextPage: true,
        ),
        const OrdersState(
          orders: BaseState(
            isLoading: false,
            errorMessage: 'Network error',
            data: null,
          ),
          currentPage: 1,
          hasNextPage: true,
        ),
      ],
      verify: (_) {
        verify(mockGetOrdersUseCase.call(page: 1, pageSize: 10)).called(1);
      },
    );
  });

  group('LoadMoreOrdersEvent', () {
    const tSecondPageOrders = [
      OrderEntity(
        id: '2',
        orderNumber: 'ORD-2',
        itemCount: 2,
        rawStatus: 'Processing',
        displayStatus: OrderDisplayStatus.active,
        total: 200,
        paymentStatus: 'Pending',
      ),
    ];

    blocTest<OrdersCubit, OrdersState>(
      'emits [isLoadingMore: true, updated orders list with page 2] on success',
      seed: () => const OrdersState(
        orders: BaseState(isLoading: false, errorMessage: null, data: tOrders),
        currentPage: 1,
        hasNextPage: true,
        isLoadingMore: false,
      ),
      build: () {
        when(mockGetOrdersUseCase.call(page: 2, pageSize: 10)).thenAnswer(
          (_) async => SuccessResponse<List<OrderEntity>>(tSecondPageOrders),
        );
        return ordersCubit;
      },
      act: (cubit) => cubit.doEvent(const LoadMoreOrdersEvent()),
      expect: () => [
        const OrdersState(
          orders: BaseState(
            isLoading: false,
            errorMessage: null,
            data: tOrders,
          ),
          currentPage: 1,
          hasNextPage: true,
          isLoadingMore: true,
        ),
        const OrdersState(
          orders: BaseState(
            isLoading: false,
            errorMessage: null,
            data: [...tOrders, ...tSecondPageOrders],
          ),
          currentPage: 2,
          hasNextPage: false,
          isLoadingMore: false,
        ),
      ],
      verify: (_) {
        verify(mockGetOrdersUseCase.call(page: 2, pageSize: 10)).called(1);
      },
    );
  });

  group('LoadOrderDetailsEvent', () {
    blocTest<OrdersCubit, OrdersState>(
      'emits [orderDetails.isLoading: true, orderDetails.success with details] on success',
      build: () {
        when(mockGetOrderDetailsUseCase.call(orderId: '1')).thenAnswer(
          (_) async => SuccessResponse<OrderDetailsEntity>(tOrderDetails),
        );
        return ordersCubit;
      },
      act: (cubit) => cubit.doEvent(const LoadOrderDetailsEvent('1')),
      expect: () => [
        const OrdersState(
          orderDetails: BaseState(
            isLoading: true,
            errorMessage: null,
            data: null,
          ),
        ),
        const OrdersState(
          orderDetails: BaseState(
            isLoading: false,
            errorMessage: null,
            data: tOrderDetails,
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetOrderDetailsUseCase.call(orderId: '1')).called(1);
      },
    );

    blocTest<OrdersCubit, OrdersState>(
      'emits [orderDetails.isLoading: true, orderDetails.error with errorMessage] on failure',
      build: () {
        when(mockGetOrderDetailsUseCase.call(orderId: '1')).thenAnswer(
          (_) async => ErrorResponse<OrderDetailsEntity>('Order not found'),
        );
        return ordersCubit;
      },
      act: (cubit) => cubit.doEvent(const LoadOrderDetailsEvent('1')),
      expect: () => [
        const OrdersState(
          orderDetails: BaseState(
            isLoading: true,
            errorMessage: null,
            data: null,
          ),
        ),
        const OrdersState(
          orderDetails: BaseState(
            isLoading: false,
            errorMessage: 'Order not found',
            data: null,
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetOrderDetailsUseCase.call(orderId: '1')).called(1);
      },
    );
  });
}
