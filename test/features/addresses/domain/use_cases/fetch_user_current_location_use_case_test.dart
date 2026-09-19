import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:flowrist/features/addresses/domain/use_cases/fetch_user_current_location_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([LocationRepository])
import 'fetch_user_current_location_use_case_test.mocks.dart';

void main() {
  provideDummy<BaseResponse<(CoordinatesEntity, String?)>>(
    SuccessResponse<(CoordinatesEntity, String?)>((
      const CoordinatesEntity(latitude: 0.0, longitude: 0.0),
      null,
    )),
  );

  late MockLocationRepository mockRepository;
  late FetchUserCurrentLocationUseCase useCase;

  setUp(() {
    mockRepository = MockLocationRepository();
    useCase = FetchUserCurrentLocationUseCase(mockRepository);
  });

  const tCoordinates = CoordinatesEntity(latitude: 30.0444, longitude: 31.2357);
  const tAddress = '123 Main St';

  group('FetchUserCurrentLocationUseCase Unit Tests', () {
    test(
      'should call repository.fetchUserCurrentLocation and return SuccessResponse',
      () async {
        final expectedResponse = SuccessResponse<(CoordinatesEntity, String?)>((
          tCoordinates,
          tAddress,
        ));

        when(
          mockRepository.fetchUserCurrentLocation(),
        ).thenAnswer((_) async => expectedResponse);

        final result = await useCase();

        expect(result, equals(expectedResponse));
        verify(mockRepository.fetchUserCurrentLocation()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should call repository.fetchUserCurrentLocation and return ErrorResponse',
      () async {
        final expectedResponse = ErrorResponse<(CoordinatesEntity, String?)>(
          'Location fetch failed',
        );

        when(
          mockRepository.fetchUserCurrentLocation(),
        ).thenAnswer((_) async => expectedResponse);

        final result = await useCase();

        expect(result, equals(expectedResponse));
        verify(mockRepository.fetchUserCurrentLocation()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
