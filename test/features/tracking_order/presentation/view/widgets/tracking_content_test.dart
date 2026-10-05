import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_destination_entity.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_driver_entity.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_location_entity.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_cubit.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_event.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_state.dart';
import 'package:flowrist/features/tracking_order/presentation/view/widgets/tracking_content.dart';
import 'package:flowrist/features/tracking_order/presentation/widgets/order_status_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackingCubit extends MockCubit<TrackingState>
    implements TrackingCubit {}

// class FakeTrackingEvent extends Fake implements TrackingEvent {}

void main() {
  late MockTrackingCubit trackingCubit;

  setUpAll(() async {
    await initializeDateFormatting();
    registerFallbackValue(ConfirmDelivery(orderId: 'fallback-order-id'));
  });

  setUp(() {
    trackingCubit = MockTrackingCubit();

    when(() => trackingCubit.state).thenReturn(
      TrackingState(
        routePoints: const [],
        isConfirmingDelivery: false,
        isDeliveryConfirmed: false,
      ),
    );

    when(() => trackingCubit.doEvent(any())).thenAnswer((_) async {});
  });

  OrderTrackingEntity createTracking({String status = 'OUT_FOR_DELIVERY'}) {
    return OrderTrackingEntity(
      orderId: 'order-123',
      orderNumber: 'FL-123',
      status: status,
      isTrackingActive: true,
      timeline: const [],
      driver: const TrackingDriverEntity(name: 'Mohamed'),
      lastKnownLocation: null,
      storeLocation: const TrackingLocationEntity(lat: 30.0561, lng: 31.3452),
      destination: TrackingDestinationEntity(
        lat: 30.03126,
        lng: 31.37762,
        recipientName: '',
        addressLine: '',
        city: '',
        area: '',
      ),
    );
  }

  Widget createWidget({
    required OrderTrackingEntity tracking,
    DateTime? estimatedDeliveryAt,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: BlocProvider<TrackingCubit>.value(
        value: trackingCubit,
        child: Scaffold(
          body: TrackingContent(
            tracking: tracking,
            estimatedDeliveryAt: estimatedDeliveryAt,
          ),
        ),
      ),
    );
  }

  group('TrackingContent', () {
    testWidgets('displays estimated delivery time', (tester) async {
      final deliveryTime = DateTime(2026, 10, 5, 16, 30);

      await tester.pumpWidget(
        createWidget(
          tracking: createTracking(),
          estimatedDeliveryAt: deliveryTime,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Estimated'), findsOneWidget);

      expect(find.textContaining('4:30'), findsOneWidget);
    });

    testWidgets(
      'displays unknown delivery time when estimatedDeliveryAt is null',
      (tester) async {
        await tester.pumpWidget(
          createWidget(tracking: createTracking(), estimatedDeliveryAt: null),
        );

        await tester.pumpAndSettle();

        final context = tester.element(find.byType(TrackingContent));
        final l10n = AppLocalizations.of(context)!;

        expect(find.text(l10n.unknownDeliveryTime), findsOneWidget);
      },
    );

    testWidgets('displays driver name', (tester) async {
      await tester.pumpWidget(
        createWidget(
          tracking: createTracking(),
          estimatedDeliveryAt: DateTime(2026, 10, 5, 16, 30),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Mohamed'), findsOneWidget);
    });

    testWidgets('displays tracking status timeline', (tester) async {
      await tester.pumpWidget(createWidget(tracking: createTracking()));

      await tester.pumpAndSettle();

      expect(find.byType(OrderStatusTimeline), findsOneWidget);
    });

    testWidgets('shows enabled Show Map button when status allows map', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidget(tracking: createTracking(status: 'OUT_FOR_DELIVERY')),
      );

      await tester.pumpAndSettle();

      final button = find.text(
        AppLocalizations.of(
          tester.element(find.byType(TrackingContent)),
        )!.showMap,
      );

      expect(button, findsOneWidget);

      final appButton = find.ancestor(
        of: button,
        matching: find.byType(ElevatedButton),
      );

      expect(appButton, findsOneWidget);
    });

    testWidgets(
      'shows delivery confirmation buttons when awaiting confirmation',
      (tester) async {
        await tester.pumpWidget(
          createWidget(
            tracking: createTracking(status: 'AWAITING_DELIVERY_CONFIRMATION'),
          ),
        );

        await tester.pumpAndSettle();

        final context = tester.element(find.byType(TrackingContent));

        final l10n = AppLocalizations.of(context)!;

        expect(find.text(l10n.showMap), findsOneWidget);

        expect(find.text(l10n.orderDelivered), findsOneWidget);
      },
    );

    testWidgets('dispatches ConfirmDelivery when Order Delivered is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidget(
          tracking: createTracking(status: 'AWAITING_DELIVERY_CONFIRMATION'),
        ),
      );

      await tester.pumpAndSettle();

      final context = tester.element(find.byType(TrackingContent));

      final l10n = AppLocalizations.of(context)!;

      final button = find.text(l10n.orderDelivered);

      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      final captured = verify(
        () => trackingCubit.doEvent(captureAny()),
      ).captured;

      expect(captured, hasLength(1));

      final event = captured.single as ConfirmDelivery;

      expect(event, isA<ConfirmDelivery>());
      expect(event.orderId, 'order-123');
    });

    testWidgets(
      'shows confirming text while delivery confirmation is in progress',
      (tester) async {
        when(() => trackingCubit.state).thenReturn(
          TrackingState(
            routePoints: const [],
            isConfirmingDelivery: true,
            isDeliveryConfirmed: false,
          ),
        );

        await tester.pumpWidget(
          createWidget(
            tracking: createTracking(status: 'AWAITING_DELIVERY_CONFIRMATION'),
          ),
        );

        await tester.pumpAndSettle();

        final context = tester.element(find.byType(TrackingContent));

        final l10n = AppLocalizations.of(context)!;

        expect(find.text(l10n.confirming), findsOneWidget);

        expect(find.text(l10n.orderDelivered), findsNothing);
      },
    );

    testWidgets('shows delivered text after delivery is confirmed', (
      tester,
    ) async {
      when(() => trackingCubit.state).thenReturn(
        TrackingState(
          routePoints: const [],
          isConfirmingDelivery: false,
          isDeliveryConfirmed: true,
        ),
      );

      await tester.pumpWidget(
        createWidget(
          tracking: createTracking(status: 'AWAITING_DELIVERY_CONFIRMATION'),
        ),
      );

      await tester.pumpAndSettle();

      final context = tester.element(find.byType(TrackingContent));

      final l10n = AppLocalizations.of(context)!;

      expect(find.text(l10n.delivered), findsOneWidget);
    });
  });
}
