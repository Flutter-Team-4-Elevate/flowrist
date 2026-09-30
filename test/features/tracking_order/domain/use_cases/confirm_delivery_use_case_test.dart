import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/tracking_order/domain/repositories/tracking_repository.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/confirm_delivery_use_case.dart';

import 'confirm_delivery_use_case_test.mocks.dart';

@GenerateMocks([TrackingRepository])
void main() {
  late MockTrackingRepository mockRepository;
  late ConfirmDeliveryUseCase useCase;

  setUp(() {
    provideDummy<BaseResponse<void>>(SuccessResponse<void>(null));
  });
  setUp(() {
    mockRepository = MockTrackingRepository();
    useCase = ConfirmDeliveryUseCase(mockRepository);
  });

  test('should confirm delivery successfully', () async {
    const orderId = 'order-123';

    final response = SuccessResponse<void>(null);

    when(
      mockRepository.confirmDelivery(orderId),
    ).thenAnswer((_) async => response);

    final result = await useCase(orderId);

    expect(result, same(response));

    verify(mockRepository.confirmDelivery(orderId)).called(1);

    verifyNoMoreInteractions(mockRepository);
  });

  test('should return error response when repository fails', () async {
    const orderId = 'order-123';

    final response = ErrorResponse<dynamic>('Failed to confirm delivery');

    when(
      mockRepository.confirmDelivery(orderId),
    ).thenAnswer((_) async => response);

    final result = await useCase(orderId);

    expect(result, same(response));

    verify(mockRepository.confirmDelivery(orderId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
