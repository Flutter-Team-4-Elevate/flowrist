import 'package:flowrist/features/addresses/domain/entities/service_status_entity.dart';
import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:flowrist/features/addresses/domain/use_cases/check_location_service_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([LocationRepository])
import 'check_location_service_use_case_test.mocks.dart';

void main() {
  late MockLocationRepository mockRepository;
  late CheckLocationServiceUseCase useCase;

  setUp(() {
    mockRepository = MockLocationRepository();
    useCase = CheckLocationServiceUseCase(mockRepository);
  });

  group('CheckLocationServiceUseCase Unit Tests', () {
    test(
      'should call repository.checkLocationService and return ServiceStatusEntity',
      () async {
        when(
          mockRepository.checkLocationService(),
        ).thenAnswer((_) async => ServiceStatusEntity.enabled);

        final result = await useCase();

        expect(result, equals(ServiceStatusEntity.enabled));
        verify(mockRepository.checkLocationService()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
