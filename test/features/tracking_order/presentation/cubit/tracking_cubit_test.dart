import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_destination_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/confirm_delivery_use_case.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/watch_order_tracking_use_case.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_cubit.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_event.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_state.dart';

import 'tracking_cubit_test.mocks.dart';

@GenerateMocks([WatchOrderTrackingUseCase, ConfirmDeliveryUseCase])
void main() {
  provideDummy<BaseResponse<dynamic>>(SuccessResponse<dynamic>(null));
  late MockWatchOrderTrackingUseCase mockWatchOrderTrackingUseCase;
  late MockConfirmDeliveryUseCase mockConfirmDeliveryUseCase;
  late TrackingCubit cubit;

  setUp(() {
    mockWatchOrderTrackingUseCase = MockWatchOrderTrackingUseCase();
    mockConfirmDeliveryUseCase = MockConfirmDeliveryUseCase();

    cubit = TrackingCubit(
      mockWatchOrderTrackingUseCase,
      mockConfirmDeliveryUseCase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('StartTracking', () {
    test('should call WatchOrderTrackingUseCase with order id', () async {
      const orderId = 'order-123';

      final controller = StreamController<OrderTrackingEntity>();

      when(
        mockWatchOrderTrackingUseCase(orderId),
      ).thenAnswer((_) => controller.stream);

      await cubit.doEvent(StartTracking(orderId: orderId));

      verify(mockWatchOrderTrackingUseCase(orderId)).called(1);

      await controller.close();
    });

    blocTest<TrackingCubit, TrackingState>(
      'should emit tracking data when stream returns tracking',
      build: () {
        const orderId = 'order-123';

        final controller = StreamController<OrderTrackingEntity>();

        when(
          mockWatchOrderTrackingUseCase(orderId),
        ).thenAnswer((_) => controller.stream);

        Future.microtask(() {
          controller.add(_createTrackingEntity(orderId));
        });

        return TrackingCubit(
          mockWatchOrderTrackingUseCase,
          mockConfirmDeliveryUseCase,
        );
      },
      act: (cubit) async {
        await cubit.doEvent(StartTracking(orderId: 'order-123'));
      },
      expect: () => [
        isA<TrackingState>()
            .having((state) => state.isLoading, 'isLoading', false)
            .having((state) => state.tracking, 'tracking', isNotNull)
            .having((state) => state.errorMessage, 'errorMessage', isNull),
      ],
    );

    blocTest<TrackingCubit, TrackingState>(
      'should emit error when tracking stream throws',
      build: () {
        const orderId = 'order-123';

        when(mockWatchOrderTrackingUseCase(orderId)).thenAnswer(
          (_) =>
              Stream<OrderTrackingEntity>.error(Exception('Tracking failed')),
        );

        return TrackingCubit(
          mockWatchOrderTrackingUseCase,
          mockConfirmDeliveryUseCase,
        );
      },
      act: (cubit) async {
        await cubit.doEvent(StartTracking(orderId: 'order-123'));
      },
      expect: () => [
        isA<TrackingState>()
            .having((state) => state.isLoading, 'isLoading', false)
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              contains('Tracking failed'),
            ),
      ],
    );
  });

  group('ConfirmDelivery', () {
    blocTest<TrackingCubit, TrackingState>(
      'should confirm delivery successfully',
      build: () {
        const orderId = 'order-123';

        when(
          mockConfirmDeliveryUseCase(orderId),
        ).thenAnswer((_) async => SuccessResponse<dynamic>(null));

        return TrackingCubit(
          mockWatchOrderTrackingUseCase,
          mockConfirmDeliveryUseCase,
        );
      },
      act: (cubit) async {
        await cubit.doEvent(ConfirmDelivery(orderId: 'order-123'));
      },
      expect: () => [
        isA<TrackingState>()
            .having(
              (state) => state.isConfirmingDelivery,
              'isConfirmingDelivery',
              true,
            )
            .having((state) => state.errorMessage, 'errorMessage', isNull),
        isA<TrackingState>()
            .having(
              (state) => state.isConfirmingDelivery,
              'isConfirmingDelivery',
              false,
            )
            .having(
              (state) => state.isDeliveryConfirmed,
              'isDeliveryConfirmed',
              true,
            ),
      ],
      verify: (_) {
        verify(mockConfirmDeliveryUseCase('order-123')).called(1);
      },
    );

    blocTest<TrackingCubit, TrackingState>(
      'should emit error when confirm delivery fails',
      build: () {
        const orderId = 'order-123';

        when(mockConfirmDeliveryUseCase(orderId)).thenAnswer(
          (_) async => ErrorResponse<dynamic>('Failed to confirm delivery'),
        );

        return TrackingCubit(
          mockWatchOrderTrackingUseCase,
          mockConfirmDeliveryUseCase,
        );
      },
      act: (cubit) async {
        await cubit.doEvent(ConfirmDelivery(orderId: 'order-123'));
      },
      expect: () => [
        isA<TrackingState>()
            .having(
              (state) => state.isConfirmingDelivery,
              'isConfirmingDelivery',
              true,
            )
            .having((state) => state.errorMessage, 'errorMessage', isNull),
        isA<TrackingState>()
            .having(
              (state) => state.isConfirmingDelivery,
              'isConfirmingDelivery',
              false,
            )
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              'Failed to confirm delivery',
            ),
      ],
      verify: (_) {
        verify(mockConfirmDeliveryUseCase('order-123')).called(1);
      },
    );
  });
}

OrderTrackingEntity _createTrackingEntity(String orderId) {
  final destination = TrackingDestinationEntity(
    addressLine: "",
    area: "",
    city: "",
    lat: 1.2,
    lng: 2.2,
    recipientName: "",
  );
  return OrderTrackingEntity(
    orderId: orderId,
    orderNumber: 'ORD-123',
    status: 'PREPARING',
    isTrackingActive: true,
    timeline: const [],
    driver: null,
    lastKnownLocation: null,
    storeLocation: null,

    // Replace this with your actual destination entity
    // constructor if destination is required.
    destination: destination,
  );
}
