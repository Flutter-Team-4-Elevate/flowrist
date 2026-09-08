import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/my_orders/data/data_sources/contract/orders_remote_data_source.dart';
import 'package:flowrist/features/home/profile/my_orders/data/models/response/order_details_response_dto.dart';
import 'package:flowrist/features/home/profile/my_orders/data/models/response/orders_response_dto.dart';
import 'package:flowrist/features/home/profile/my_orders/data/repositories/orders_repository_impl.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_details_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/paginated_orders_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'orders_repository_impl_test.mocks.dart';

@GenerateMocks([OrdersRemoteDataSource])
void main() {
  late MockOrdersRemoteDataSource mockRemoteDataSource;
  late OrdersRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockOrdersRemoteDataSource();
    repository = OrdersRepositoryImpl(mockRemoteDataSource);
  });

  group('getOrders', () {
    const tResponseDto = OrdersResponseDto(
      status: true,
      data: [
        OrderItemDto(
          id: '1',
          orderNumber: 'ORD-1',
          status: 'Processing',
          total: 100,
        ),
      ],
      pagination: OrdersPaginationDto(
        page: 1,
        pageSize: 10,
        totalCount: 1,
        totalPages: 1,
        hasNextPage: false,
        hasPreviousPage: false,
      ),
    );

    test(
      'should return SuccessResponse<PaginatedOrdersEntity> when data source succeeds',
      () async {
        when(
          mockRemoteDataSource.getOrders(page: 1, pageSize: 10),
        ).thenAnswer((_) async => tResponseDto);

        final result = await repository.getOrders(page: 1, pageSize: 10);

        expect(result, isA<SuccessResponse<PaginatedOrdersEntity>>());
        final data = (result as SuccessResponse<PaginatedOrdersEntity>).data;
        expect(data?.orders.first.id, '1');
        expect(data?.currentPage, 1);
        expect(data?.hasNextPage, false);
        verify(mockRemoteDataSource.getOrders(page: 1, pageSize: 10)).called(1);
      },
    );

    test(
      'should return ErrorResponse<PaginatedOrdersEntity> when data source throws an exception',
      () async {
        when(
          mockRemoteDataSource.getOrders(page: 1, pageSize: 10),
        ).thenThrow(Exception('Server error'));

        final result = await repository.getOrders(page: 1, pageSize: 10);

        expect(result, isA<ErrorResponse<PaginatedOrdersEntity>>());
        verify(mockRemoteDataSource.getOrders(page: 1, pageSize: 10)).called(1);
      },
    );
  });

  group('getOrderDetails', () {
    const tDetailsDto = OrderDetailsResponseDto(
      status: true,
      data: OrderDetailsDataDto(id: '10', orderNumber: 'ORD-10', total: 500),
    );

    test(
      'should return SuccessResponse<OrderDetailsEntity> when data source succeeds',
      () async {
        when(
          mockRemoteDataSource.getOrderDetails(orderId: '10'),
        ).thenAnswer((_) async => tDetailsDto);

        final result = await repository.getOrderDetails(orderId: '10');

        expect(result, isA<SuccessResponse<OrderDetailsEntity>>());
        final data = (result as SuccessResponse<OrderDetailsEntity>).data;
        expect(data?.id, '10');
        verify(mockRemoteDataSource.getOrderDetails(orderId: '10')).called(1);
      },
    );

    test(
      'should return ErrorResponse when data source throws an exception',
      () async {
        when(
          mockRemoteDataSource.getOrderDetails(orderId: '10'),
        ).thenThrow(Exception('Details error'));

        final result = await repository.getOrderDetails(orderId: '10');

        expect(result, isA<ErrorResponse<OrderDetailsEntity>>());
        verify(mockRemoteDataSource.getOrderDetails(orderId: '10')).called(1);
      },
    );
  });
}
