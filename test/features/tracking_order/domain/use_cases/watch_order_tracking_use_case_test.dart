import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flowrist/features/tracking_order/domain/repositories/tracking_repository.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/watch_order_tracking_use_case.dart';

import 'confirm_delivery_use_case_test.mocks.dart';

@GenerateMocks([TrackingRepository])
void main() {
  late MockTrackingRepository mockRepository;
  late WatchOrderTrackingUseCase useCase;

  setUp(() {
    mockRepository = MockTrackingRepository();
    useCase = WatchOrderTrackingUseCase(mockRepository);
  });

  test('should call repository watchOrderTracking', () {
    const orderId = 'order-123';

    final controller = StreamController<OrderTrackingEntity>.broadcast();

    when(
      mockRepository.watchOrderTracking(orderId),
    ).thenAnswer((_) => controller.stream);

    final result = useCase(orderId);

    expect(result, isA<Stream<OrderTrackingEntity>>());

    verify(mockRepository.watchOrderTracking(orderId)).called(1);

    controller.close();
  });
}
