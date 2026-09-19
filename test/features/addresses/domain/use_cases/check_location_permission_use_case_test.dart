import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';
import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:flowrist/features/addresses/domain/use_cases/check_location_permission_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([LocationRepository])
import 'check_location_permission_use_case_test.mocks.dart';

void main() {
  late MockLocationRepository mockRepository;
  late CheckLocationPermissionUseCase useCase;

  setUp(() {
    mockRepository = MockLocationRepository();
    useCase = CheckLocationPermissionUseCase(mockRepository);
  });

  group('CheckLocationPermissionUseCase Unit Tests', () {
    test(
      'should call repository.checkLocationPermission and return PermissionStatusEntity',
      () async {
        when(
          mockRepository.checkLocationPermission(),
        ).thenAnswer((_) async => PermissionStatusEntity.granted);

        final result = await useCase();

        expect(result, equals(PermissionStatusEntity.granted));
        verify(mockRepository.checkLocationPermission()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
