import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_destination_entity.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_driver_entity.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_location_entity.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_timeline_entity.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_cubit.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_event.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackingCubit extends MockCubit<TrackingState>
    implements TrackingCubit {}

class MockGoRouter extends Mock implements GoRouter {}

MockTrackingCubit createCubit() {
  // Needed once so `any()` works for TrackingEvent parameters.
  registerFallbackValue(ConfirmDelivery(orderId: 'fallback'));

  final cubit = MockTrackingCubit();
  when(() => cubit.state).thenReturn(const TrackingState());
  when(() => cubit.doEvent(any())).thenAnswer((_) async {});
  return cubit;
}

MockGoRouter createRouter() {
  final router = MockGoRouter();

  when(
    () => router.push<Object?>(any(), extra: any(named: 'extra')),
  ).thenAnswer((_) async => null);

  when(() => router.go(any(), extra: any(named: 'extra'))).thenReturn(null);

  return router;
}

OrderTrackingEntity buildTracking({
  String status = 'PREPARING',
  String orderId = 'order-1',
  String orderNumber = '#1001',
  bool isTrackingActive = true,
  List<TrackingTimelineEntity>? timeline,
  TrackingDriverEntity? driver = const TrackingDriverEntity(name: 'Ahmed'),
}) {
  return OrderTrackingEntity(
    orderId: orderId,
    orderNumber: orderNumber,
    status: status,
    isTrackingActive: isTrackingActive,
    timeline: timeline ?? const [],
    driver: driver,
    lastKnownLocation: const TrackingLocationEntity(lat: 30.1, lng: 31.1),
    storeLocation: const TrackingLocationEntity(lat: 30.2, lng: 31.2),
    destination: const TrackingDestinationEntity(
      lat: 30.0,
      lng: 31.0,
      recipientName: 'Sara',
      addressLine: '12 Nile St',
      city: 'Cairo',
      area: 'Maadi',
    ),
  );
}

TrackingTimelineEntity buildTimelineItem({
  String status = 'PLACED',
  DateTime? occurredAt,
  bool isCompleted = false,
  bool isCurrent = false,
}) {
  return TrackingTimelineEntity(
    status: status,
    occurredAt: occurredAt,
    isCompleted: isCompleted,
    isCurrent: isCurrent,
  );
}

Future<void> pumpScreen(
  WidgetTester tester,
  Widget child, {
  required MockTrackingCubit cubit,
  required MockGoRouter router,
  TrackingState? state,
}) async {
  // Tall screen so scrollable content is fully visible.
  tester.view.physicalSize = const Size(1080, 2600);
  tester.view.devicePixelRatio = 2.0;
  addTearDown(tester.view.reset);

  if (state != null) {
    when(() => cubit.state).thenReturn(state);
  }

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: InheritedGoRouter(
        goRouter: router,
        child: BlocProvider<TrackingCubit>.value(value: cubit, child: child),
      ),
    ),
  );
  await tester.pump();
}

AppLocalizations l10nOf(WidgetTester tester, Type widgetType) =>
    AppLocalizations.of(tester.element(find.byType(widgetType)))!;
