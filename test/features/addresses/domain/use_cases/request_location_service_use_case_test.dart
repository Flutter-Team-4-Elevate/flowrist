import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:flowrist/features/addresses/domain/use_cases/request_location_service_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([LocationRepository])
import 'request_location_service_use_case_test.mocks.dart';

void main() {
  late MockLocationRepository mockRepository;
  late RequestLocationServiceUseCase useCase;

  setUp(() {
    mockRepository = MockLocationRepository();
    useCase = RequestLocationServiceUseCase(mockRepository);
  });

  group('RequestLocationServiceUseCase Unit Tests', () {
    test(
      'should call repository.requestLocationService and return boolean result',
      () async {
        when(
          mockRepository.requestLocationService(),
        ).thenAnswer((_) async => true);

        final result = await useCase();

        expect(result, isTrue);
        verify(mockRepository.requestLocationService()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
