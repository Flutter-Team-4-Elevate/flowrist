import 'package:flowrist/features/tracking_order/presentation/widgets/order_status_item.dart';
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

  Widget item({
    String date = '',
    bool isCompleted = false,
    bool isCurrent = false,
    bool isLast = false,
  }) {
    return Scaffold(
      body: OrderStatusItem(
        title: 'Preparing your order',
        date: date,
        isCompleted: isCompleted,
        isCurrent: isCurrent,
        isLast: isLast,
      ),
    );
  }

  Future<void> pump(WidgetTester tester, Widget w) =>
      pumpScreen(tester, w, cubit: cubit, router: router);

  final connector = find.byWidgetPredicate(
    (w) =>
        w is Container &&
        w.constraints?.maxWidth == 1 &&
        w.constraints?.maxHeight == 57,
  );
  final innerDot = find.byWidgetPredicate(
    (w) =>
        w is Container &&
        w.constraints?.maxWidth == 8 &&
        w.constraints?.maxHeight == 8,
  );

  group('OrderStatusItem', () {
    testWidgets('shows title', (tester) async {
      await pump(tester, item());
      expect(find.text('Preparing your order'), findsOneWidget);
    });

    testWidgets('shows date only when provided', (tester) async {
      await pump(tester, item(date: '01 Jan 2026 - 10:00'));
      expect(find.text('01 Jan 2026 - 10:00'), findsOneWidget);

      await pump(tester, item());
      expect(find.text('01 Jan 2026 - 10:00'), findsNothing);
    });

    testWidgets('shows connector line when not last', (tester) async {
      await pump(tester, item(isLast: false));
      expect(connector, findsOneWidget);
    });

    testWidgets('hides connector line when last', (tester) async {
      await pump(tester, item(isLast: true));
      expect(connector, findsNothing);
    });

    testWidgets('connector is pink when completed, grey otherwise', (
      tester,
    ) async {
      await pump(tester, item(isCompleted: true));
      expect(tester.widget<Container>(connector).color, Colors.pink);

      await pump(tester, item());
      expect(tester.widget<Container>(connector).color, Colors.grey);
    });

    testWidgets('shows inner dot when current or completed', (tester) async {
      await pump(tester, item(isCurrent: true));
      expect(innerDot, findsOneWidget);

      await pump(tester, item(isCompleted: true));
      expect(innerDot, findsOneWidget);
    });

    testWidgets('hides inner dot when inactive', (tester) async {
      await pump(tester, item());
      expect(innerDot, findsNothing);
    });
  });
}
