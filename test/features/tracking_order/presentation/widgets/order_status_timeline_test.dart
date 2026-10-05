import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_state.dart';
import 'package:flowrist/features/tracking_order/presentation/view/track_order_details.dart';
import 'package:flowrist/features/tracking_order/presentation/view/widgets/tracking_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../view/helpers/tracking_test_helpers.dart';

void main() {
  late MockTrackingCubit cubit;
  late MockGoRouter router;

  setUp(() {
    cubit = createCubit();
    router = createRouter();
  });

  Future<void> pump(WidgetTester tester, [TrackingState? state]) => pumpScreen(
    tester,
    const TrackOrderDetails(),
    cubit: cubit,
    router: router,
    state: state,
  );

  group('TrackOrderDetails', () {
    testWidgets('shows loader while loading with no data', (tester) async {
      await pump(tester, const TrackingState(isLoading: true));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when failed with no data', (tester) async {
      await pump(
        tester,
        const TrackingState(errorMessage: 'Something went wrong'),
      );
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('shows fallback text when there is no tracking', (
      tester,
    ) async {
      await pump(tester);
      final l10n = l10nOf(tester, TrackOrderDetails);
      expect(find.text(l10n.noDataTryAgain), findsOneWidget);
    });

    testWidgets('shows WaitingForDriverView when status is PLACED', (
      tester,
    ) async {
      await pump(
        tester,
        TrackingState(tracking: buildTracking(status: 'PLACED')),
      );

      expect(find.byType(WaitingForDriverView), findsOneWidget);
      expect(find.byType(TrackingContent), findsNothing);
    });

    testWidgets('shows the app bar title', (tester) async {
      await pump(tester);
      final l10n = l10nOf(tester, TrackOrderDetails);
      expect(find.text(l10n.trackOrder), findsOneWidget);
    });
  });
}
