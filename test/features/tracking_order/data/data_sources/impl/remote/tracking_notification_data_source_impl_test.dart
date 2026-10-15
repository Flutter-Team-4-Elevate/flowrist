import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flowrist/features/tracking_order/data/data_sources/impl/remote/tracking_notification_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/notifications/notification_service.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_update_entity.dart';

import '../../../../../auth/data/repositories/auth_repository_impl_test.mocks.dart';

@GenerateMocks([PushNotificationsServices])
void main() {
  late MockPushNotificationsServices mockNotificationsService;
  late TrackingNotificationDataSourceImpl dataSource;
  late StreamController<RemoteMessage> messageController;

  setUp(() {
    mockNotificationsService = MockPushNotificationsServices();

    messageController = StreamController<RemoteMessage>.broadcast();

    when(
      mockNotificationsService.messages,
    ).thenAnswer((_) => messageController.stream);

    dataSource = TrackingNotificationDataSourceImpl(mockNotificationsService);
  });

  tearDown(() async {
    await messageController.close();
  });

  test(
    'should emit TrackingUpdateEntity when tracking notification is received',
    () async {
      // Arrange
      final future = expectLater(
        dataSource.trackingUpdates,
        emits(
          isA<TrackingUpdateEntity>()
              .having((update) => update.orderId, 'orderId', 'order-123')
              .having((update) => update.status, 'status', 'PREPARING'),
        ),
      );

      // Act
      messageController.add(
        RemoteMessage(
          data: {
            'type': 'ORDER_TRACKING_UPDATED',
            'orderId': 'order-123',
            'status': 'PREPARING',
          },
        ),
      );

      // Assert
      await future;
    },
  );

  test(
    'should ignore notification when type is not ORDER_TRACKING_UPDATED',
    () async {
      // Arrange
      final updates = <TrackingUpdateEntity>[];

      final subscription = dataSource.trackingUpdates.listen(updates.add);

      // Act
      messageController.add(
        RemoteMessage(
          data: {
            'type': 'OTHER_NOTIFICATION',
            'orderId': 'order-123',
            'status': 'PREPARING',
          },
        ),
      );

      await Future<void>.delayed(Duration.zero);

      // Assert
      expect(updates, isEmpty);

      await subscription.cancel();
    },
  );

  test('should map orderId correctly', () async {
    // Arrange
    final future = expectLater(
      dataSource.trackingUpdates,
      emits(
        isA<TrackingUpdateEntity>().having(
          (update) => update.orderId,
          'orderId',
          'order-456',
        ),
      ),
    );

    // Act
    messageController.add(
      RemoteMessage(
        data: {
          'type': 'ORDER_TRACKING_UPDATED',
          'orderId': 'order-456',
          'status': 'PICKED_UP',
        },
      ),
    );

    // Assert
    await future;
  });

  test('should map status correctly', () async {
    // Arrange
    final future = expectLater(
      dataSource.trackingUpdates,
      emits(
        isA<TrackingUpdateEntity>().having(
          (update) => update.status,
          'status',
          'OUT_FOR_DELIVERY',
        ),
      ),
    );

    // Act
    messageController.add(
      RemoteMessage(
        data: {
          'type': 'ORDER_TRACKING_UPDATED',
          'orderId': 'order-789',
          'status': 'OUT_FOR_DELIVERY',
        },
      ),
    );

    // Assert
    await future;
  });

  test('should allow null status', () async {
    // Arrange
    final future = expectLater(
      dataSource.trackingUpdates,
      emits(
        isA<TrackingUpdateEntity>()
            .having((update) => update.orderId, 'orderId', 'order-123')
            .having((update) => update.status, 'status', null),
      ),
    );

    // Act
    messageController.add(
      RemoteMessage(
        data: {'type': 'ORDER_TRACKING_UPDATED', 'orderId': 'order-123'},
      ),
    );

    // Assert
    await future;
  });
}
