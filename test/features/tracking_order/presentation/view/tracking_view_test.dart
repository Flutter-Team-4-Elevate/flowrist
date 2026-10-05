import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/features/tracking_order/presentation/view/tracking_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/tracking_test_helpers.dart';

void main() {
  late MockTrackingCubit cubit;
  late MockGoRouter router;

  setUp(() {
    cubit = createCubit();
    router = createRouter();
  });

  Future<void> pump(WidgetTester tester) => pumpScreen(
    tester,
    const TrackingView(orderId: 'order-42'),
    cubit: cubit,
    router: router,
  );

  group('TrackingView', () {
    testWidgets('shows success message and Track Order button', (tester) async {
      await pump(tester);
      final l10n = l10nOf(tester, TrackingView);

      expect(find.text(l10n.orderPlacedSuccessfully), findsOneWidget);
      expect(find.text(l10n.trackOrder), findsNWidgets(2)); // title + button
    });

    testWidgets('Track Order pushes details with the order id', (tester) async {
      await pump(tester);

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      verify(
        () => router.push<Object?>(
          AppRoutes.trackOrderDetails,
          extra: 'order-42',
        ),
      ).called(1);
    });

    testWidgets('back arrow goes to the home tab', (tester) async {
      await pump(tester);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();

      verify(
        () => router.go(AppRoutes.homeTab, extra: any(named: 'extra')),
      ).called(1);
    });
  });
}
