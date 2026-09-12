import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flowrist/features/addresses/domain/repositories/location_repository.dart';
import 'package:flowrist/features/addresses/domain/use_cases/get_address_from_location_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([LocationRepository])
import 'get_address_from_location_use_case_test.mocks.dart';

void main() {
  provideDummy<BaseResponse<String?>>(SuccessResponse<String?>(''));

  late MockLocationRepository mockRepository;
  late GetAddressFromLocationUseCase useCase;

  setUp(() {
    mockRepository = MockLocationRepository();
    useCase = GetAddressFromLocationUseCase(mockRepository);
  });

  const tCoordinates = CoordinatesEntity(latitude: 30.0444, longitude: 31.2357);
  const tAddress = '123 Main St';

  group('GetAddressFromLocationUseCase Unit Tests', () {
    test(
      'should call repository.getAddressFromLocation and return SuccessResponse',
      () async {
        final expectedResponse = SuccessResponse<String?>(tAddress);

        when(
          mockRepository.getAddressFromLocation(tCoordinates),
        ).thenAnswer((_) async => expectedResponse);

        final result = await useCase(tCoordinates);

        expect(result, equals(expectedResponse));
        verify(mockRepository.getAddressFromLocation(tCoordinates)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should call repository.getAddressFromLocation and return ErrorResponse',
      () async {
        final expectedResponse = ErrorResponse<String?>('Address not found');

        when(
          mockRepository.getAddressFromLocation(tCoordinates),
        ).thenAnswer((_) async => expectedResponse);

        final result = await useCase(tCoordinates);

        expect(result, equals(expectedResponse));
        verify(mockRepository.getAddressFromLocation(tCoordinates)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
