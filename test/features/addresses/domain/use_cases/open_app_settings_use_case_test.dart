import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:flowrist/features/addresses/domain/use_cases/open_app_settings_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([LocationRepository])
import 'open_app_settings_use_case_test.mocks.dart';

void main() {
  late MockLocationRepository mockRepository;
  late OpenAppSettingsUseCase useCase;

  setUp(() {
    mockRepository = MockLocationRepository();
    useCase = OpenAppSettingsUseCase(mockRepository);
  });

  group('OpenAppSettingsUseCase Unit Tests', () {
    test(
      'should call repository.openAppSettings and return boolean result',
      () async {
        when(mockRepository.openAppSettings()).thenAnswer((_) async => true);

        final result = await useCase();

        expect(result, isTrue);
        verify(mockRepository.openAppSettings()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
