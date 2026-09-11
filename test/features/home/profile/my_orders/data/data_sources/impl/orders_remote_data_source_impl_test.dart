import 'package:flowrist/features/home/profile/my_orders/data/data_sources/impl/orders_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/features/home/profile/my_orders/data/client/orders_api_client.dart';
import 'package:flowrist/features/home/profile/my_orders/data/models/response/order_details_response_dto.dart';
import 'package:flowrist/features/home/profile/my_orders/data/models/response/orders_response_dto.dart';

import 'orders_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([OrdersApiClient])
void main() {
  late MockOrdersApiClient mockApiClient;
  late OrdersRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockApiClient = MockOrdersApiClient();
    remoteDataSource = OrdersRemoteDataSourceImpl(mockApiClient);
  });

  group('getOrders', () {
    const tResponse = OrdersResponseDto(
      status: true,
      data: [OrderItemDto(id: '1', orderNumber: 'ORD-101')],
    );

    test(
      'should call apiClient.getOrders with correct params and return OrdersResponseDto',
      () async {
        when(
          mockApiClient.getOrders(page: 1, pageSize: 10),
        ).thenAnswer((_) async => tResponse);

        final result = await remoteDataSource.getOrders(page: 1, pageSize: 10);

        expect(result, equals(tResponse));
        verify(mockApiClient.getOrders(page: 1, pageSize: 10)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('should rethrow exception when apiClient.getOrders fails', () async {
      when(
        mockApiClient.getOrders(page: 1, pageSize: 10),
      ).thenThrow(Exception('API error'));

      expect(
        () => remoteDataSource.getOrders(page: 1, pageSize: 10),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.getOrders(page: 1, pageSize: 10)).called(1);
    });
  });

  group('getOrderDetails', () {
    const tDetailsResponse = OrderDetailsResponseDto(
      status: true,
      data: OrderDetailsDataDto(id: '1', orderNumber: 'ORD-101'),
    );

    test(
      'should call apiClient.getOrderDetails with correct orderId and return OrderDetailsResponseDto',
      () async {
        when(
          mockApiClient.getOrderDetails(orderId: '1'),
        ).thenAnswer((_) async => tDetailsResponse);

        final result = await remoteDataSource.getOrderDetails(orderId: '1');

        expect(result, equals(tDetailsResponse));
        verify(mockApiClient.getOrderDetails(orderId: '1')).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should rethrow exception when apiClient.getOrderDetails fails',
      () async {
        when(
          mockApiClient.getOrderDetails(orderId: '1'),
        ).thenThrow(Exception('API error'));

        expect(
          () => remoteDataSource.getOrderDetails(orderId: '1'),
          throwsA(isA<Exception>()),
        );
        verify(mockApiClient.getOrderDetails(orderId: '1')).called(1);
      },
    );
  });
}
