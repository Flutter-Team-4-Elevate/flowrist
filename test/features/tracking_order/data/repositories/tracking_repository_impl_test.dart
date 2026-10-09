import 'dart:async';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/notifications/local_notification_service.dart';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/features/tracking_order/data/data_sources/contract/remote/tracking_notification_data_source.dart';
import 'package:flowrist/features/tracking_order/data/data_sources/contract/remote/tracking_remote_data_source.dart';
import 'package:flowrist/features/tracking_order/data/models/order_tracking_model.dart';
import 'package:flowrist/features/tracking_order/data/models/tracking_destination_model.dart';
import 'package:flowrist/features/tracking_order/data/repositories/tracking_repository_impl.dart';
import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_update_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../config/l10n/cubit/app_language_cubit_test.mocks.dart';
import 'tracking_repository_impl_test.mocks.dart' hide MockSecureStorageService;

@GenerateMocks([
  TrackingRemoteDataSource,
  TrackingNotificationDataSource,
  SecureStorageService,
  LocalNotificationService,
])
void main() {
  provideDummy<BaseResponse<OrderTrackingModel>>(
    SuccessResponse<OrderTrackingModel>(null),
  );

  provideDummy<BaseResponse<void>>(SuccessResponse<void>(null));
  late MockTrackingRemoteDataSource mockRemoteDataSource;
  late MockTrackingNotificationDataSource mockNotificationDataSource;
  late MockSecureStorageService mockSecureStorage;
  late TrackingRepositoryImpl repository;
  late MockLocalNotificationService localNotificationService;
  late StreamController<TrackingUpdateEntity> notificationController;

  setUp(() {
    mockRemoteDataSource = MockTrackingRemoteDataSource();
    mockNotificationDataSource = MockTrackingNotificationDataSource();
    mockSecureStorage = MockSecureStorageService();
    localNotificationService = MockLocalNotificationService();
    notificationController = StreamController<TrackingUpdateEntity>.broadcast();

    when(
      mockNotificationDataSource.trackingUpdates,
    ).thenAnswer((_) => notificationController.stream);

    repository = TrackingRepositoryImpl(
      mockRemoteDataSource,
      mockNotificationDataSource,
      mockSecureStorage,
      localNotificationService,
    );
  });

  tearDown(() async {
    await repository.dispose();
    await notificationController.close();
  });

  group('watchOrderTracking', () {
    test(
      'should emit SuccessResponse when API returns tracking data',
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

        when(
          mockRemoteDataSource.getOrderTracking(orderId),
        ).thenAnswer((_) async => SuccessResponse(tracking));

        // Act
        final stream = repository.watchOrderTracking(orderId);

        // Assert
        await expectLater(
          stream,
          emits(
            isA<SuccessResponse<OrderTrackingEntity>>()
                .having(
                  (response) => response.data?.orderId,
                  'orderId',
                  orderId,
                )
                .having(
                  (response) => response.data?.status,
                  'status',
                  'PREPARING',
                ),
          ),
        );

        verify(mockRemoteDataSource.getOrderTracking(orderId)).called(1);
      },
    );

    test('should emit ErrorResponse when API returns ErrorResponse', () async {
      // Arrange
      const orderId = '33333333-3333-3333-3333-333333333333';

      when(
        mockRemoteDataSource.getOrderTracking(orderId),
      ).thenAnswer((_) async => ErrorResponse('Order tracking not found'));

      // Act
      final stream = repository.watchOrderTracking(orderId);

      // Assert
      await expectLater(
        stream,
        emits(
          isA<ErrorResponse<OrderTrackingEntity>>().having(
            (response) => response.errorMessage,
            'errorMessage',
            'Order tracking not found',
          ),
        ),
      );

      verify(mockRemoteDataSource.getOrderTracking(orderId)).called(1);
    });

    test('should emit ErrorResponse when tracking data is null', () async {
      // Arrange
      const orderId = '33333333-3333-3333-3333-333333333333';

      when(
        mockRemoteDataSource.getOrderTracking(orderId),
      ).thenAnswer((_) async => SuccessResponse<OrderTrackingModel>(null));

      // Act
      final stream = repository.watchOrderTracking(orderId);

      // Assert
      await expectLater(
        stream,
        emits(
          isA<ErrorResponse<OrderTrackingEntity>>().having(
            (response) => response.errorMessage,
            'errorMessage',
            'Tracking data is empty',
          ),
        ),
      );

      verify(mockRemoteDataSource.getOrderTracking(orderId)).called(1);
    });
  });

  group('notification updates', () {
    test(
      'should fetch updated tracking when matching order notification is received',
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

        final initialTracking = OrderTrackingModel(
          orderId: orderId,
          orderNumber: 'ORD-001',
          status: 'PREPARING',
          isTrackingActive: true,
          timeline: [],
          destination: destination,
        );

        final updatedTracking = OrderTrackingModel(
          orderId: orderId,
          orderNumber: 'ORD-001',
          status: 'PICKED_UP',
          isTrackingActive: true,
          timeline: [],
          destination: destination,
        );

        when(
          mockRemoteDataSource.getOrderTracking(orderId),
        ).thenAnswer((_) async => SuccessResponse(initialTracking));

        // First subscription.
        final stream = repository.watchOrderTracking(orderId);

        final emitted = <BaseResponse<OrderTrackingEntity>>[];

        final subscription = stream.listen(emitted.add);

        // Allow initial API call and listener setup.
        await Future<void>.delayed(Duration.zero);

        // Second API response after notification.
        when(
          mockRemoteDataSource.getOrderTracking(orderId),
        ).thenAnswer((_) async => SuccessResponse(updatedTracking));

        // Act
        notificationController.add(
          TrackingUpdateEntity(orderId: orderId, status: 'PICKED_UP'),
        );

        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(emitted.length, 2);

        expect(emitted[0], isA<SuccessResponse<OrderTrackingEntity>>());

        expect(emitted[1], isA<SuccessResponse<OrderTrackingEntity>>());

        final firstResponse =
            emitted[0] as SuccessResponse<OrderTrackingEntity>;

        final secondResponse =
            emitted[1] as SuccessResponse<OrderTrackingEntity>;

        expect(firstResponse.data?.status, 'PREPARING');

        expect(secondResponse.data?.status, 'PICKED_UP');

        verify(mockRemoteDataSource.getOrderTracking(orderId)).called(2);

        await subscription.cancel();
      },
    );
  });

  group('confirmDelivery', () {
    test(
      'should return SuccessResponse when delivery confirmation succeeds',
      () async {
        // Arrange
        const orderId = '33333333-3333-3333-3333-333333333333';

        when(
          mockRemoteDataSource.confirmDelivery(orderId),
        ).thenAnswer((_) async => SuccessResponse(null));

        // Act
        final result = await repository.confirmDelivery(orderId);

        // Assert
        expect(result, isA<SuccessResponse<dynamic>>());

        final success = result as SuccessResponse<dynamic>;

        expect(success.data, isNull);

        verify(mockRemoteDataSource.confirmDelivery(orderId)).called(1);
      },
    );

    test(
      'should return ErrorResponse when delivery confirmation fails',
      () async {
        // Arrange
        const orderId = '33333333-3333-3333-3333-333333333333';

        when(
          mockRemoteDataSource.confirmDelivery(orderId),
        ).thenAnswer((_) async => ErrorResponse('Unable to confirm delivery'));

        // Act
        final result = await repository.confirmDelivery(orderId);

        // Assert
        expect(result, isA<ErrorResponse<dynamic>>());

        final error = result as ErrorResponse<dynamic>;

        expect(error.errorMessage, 'Unable to confirm delivery');

        verify(mockRemoteDataSource.confirmDelivery(orderId)).called(1);
      },
    );
  });
}
