import 'package:flowrist/features/tracking_order/data/data_sources/impl/remote/tracking_remote_data_source_impl.dart';
import 'package:flowrist/features/tracking_order/data/models/tracking_destination_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/tracking_order/data/client/tracking_api_client.dart';
import 'package:flowrist/features/tracking_order/data/models/order_tracking_model.dart';
import 'package:flowrist/features/tracking_order/data/models/order_tracking_response_model.dart';

import 'tracking_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([TrackingApiClient])
void main() {
  late MockTrackingApiClient mockApiClient;
  late TrackingRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockTrackingApiClient();
    dataSource = TrackingRemoteDataSourceImpl(mockApiClient);
  });

  group('getOrderTracking', () {
    test(
      'should return SuccessResponse when API returns order tracking successfully',
      () async {
        // Arrange
        const orderId = '33333333-3333-3333-3333-333333333333';
        final destination = TrackingDestinationModel(
          addressLine: "",
          area: "",
          city: "",
          lat: 1.2,
          lng: 2.2,
          recipientName: "",
        );
        final tracking = OrderTrackingModel(
          orderId: orderId,
          orderNumber: 'ORD-001',
          status: 'PREPARING',
          isTrackingActive: true,
          timeline: [],
          destination: destination,
        );

        final response = OrderTrackingResponseModel(
          status: true,
          code: 200,
          message: 'Order tracking retrieved successfully',
          data: tracking,
        );

        when(
          mockApiClient.getOrderTracking(orderId),
        ).thenAnswer((_) async => response);

        // Act
        final result = await dataSource.getOrderTracking(orderId);

        // Assert
        expect(result, isA<SuccessResponse<OrderTrackingModel>>());

        final success = result as SuccessResponse<OrderTrackingModel>;

        expect(success.data, tracking);

        verify(mockApiClient.getOrderTracking(orderId)).called(1);
      },
    );

    test('should return ErrorResponse when API returns an error', () async {
      // Arrange
      const orderId = 'invalid-order-id';

      final response = const OrderTrackingResponseModel(
        status: false,
        code: 404,
        message: 'Order tracking not found',
        data: null,
      );

      when(
        mockApiClient.getOrderTracking(orderId),
      ).thenAnswer((_) async => response);

      // Act
      final result = await dataSource.getOrderTracking(orderId);

      // Assert
      expect(result, isA<ErrorResponse<OrderTrackingModel>>());

      final error = result as ErrorResponse<OrderTrackingModel>;

      expect(error.errorMessage, 'Order tracking not found');

      verify(mockApiClient.getOrderTracking(orderId)).called(1);
    });

    test('should return ErrorResponse when API throws an exception', () async {
      // Arrange
      const orderId = '33333333-3333-3333-3333-333333333333';

      when(
        mockApiClient.getOrderTracking(orderId),
      ).thenThrow(Exception('Network error'));

      // Act
      final result = await dataSource.getOrderTracking(orderId);

      // Assert
      expect(result, isA<ErrorResponse<OrderTrackingModel>>());

      final error = result as ErrorResponse<OrderTrackingModel>;

      expect(
        error.errorMessage,
        'Something went wrong. Please try again later.',
      );

      verify(mockApiClient.getOrderTracking(orderId)).called(1);
    });
  });

  group('confirmDelivery', () {
    test(
      'should return SuccessResponse when delivery is confirmed successfully',
      () async {
        // Arrange
        const orderId = '33333333-3333-3333-3333-333333333333';

        when(mockApiClient.confirmDelivery(orderId)).thenAnswer((_) async {});

        // Act
        final result = await dataSource.confirmDelivery(orderId);

        // Assert
        expect(result, isA<SuccessResponse<dynamic>>());

        final success = result as SuccessResponse<dynamic>;

        expect(success.data, isNull);

        verify(mockApiClient.confirmDelivery(orderId)).called(1);
      },
    );

    test(
      'should return ErrorResponse when confirmDelivery throws an exception',
      () async {
        // Arrange
        const orderId = '33333333-3333-3333-3333-333333333333';

        when(
          mockApiClient.confirmDelivery(orderId),
        ).thenThrow(Exception('Network error'));

        // Act
        final result = await dataSource.confirmDelivery(orderId);

        // Assert
        expect(result, isA<ErrorResponse<dynamic>>());

        final error = result as ErrorResponse<dynamic>;

        expect(
          error.errorMessage,
          'Something went wrong. Please try again later.',
        );

        verify(mockApiClient.confirmDelivery(orderId)).called(1);
      },
    );
  });
}
