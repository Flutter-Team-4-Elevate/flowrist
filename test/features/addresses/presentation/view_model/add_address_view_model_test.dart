import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/core/config/app_config.dart';
import 'package:flowrist/core/constants/app_strings.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/service_status_entity.dart';
import 'package:flowrist/features/addresses/domain/use_cases/check_location_permission_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/check_location_service_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/fetch_user_current_location_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/get_address_from_location_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/open_app_settings_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/request_location_permission_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/request_location_service_use_case.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_event.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_state.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  CheckLocationPermissionUseCase,
  RequestLocationPermissionUseCase,
  CheckLocationServiceUseCase,
  RequestLocationServiceUseCase,
  OpenAppSettingsUseCase,
  FetchUserCurrentLocationUseCase,
  GetAddressFromLocationUseCase,
  AppConfig,
])
import 'add_address_view_model_test.mocks.dart';

void main() {
  provideDummy<BaseResponse<(CoordinatesEntity, String?)>>(
    SuccessResponse<(CoordinatesEntity, String?)>((
      const CoordinatesEntity(latitude: 0, longitude: 0),
      null,
    )),
  );
  provideDummy<BaseResponse<String?>>(SuccessResponse<String?>(null));

  late MockCheckLocationPermissionUseCase mockCheckPermission;
  late MockRequestLocationPermissionUseCase mockRequestPermission;
  late MockCheckLocationServiceUseCase mockCheckService;
  late MockRequestLocationServiceUseCase mockRequestService;
  late MockOpenAppSettingsUseCase mockOpenAppSettings;
  late MockFetchUserCurrentLocationUseCase mockFetchLocation;
  late MockGetAddressFromLocationUseCase mockGetAddress;
  late MockAppConfig mockAppConfig;

  setUp(() {
    mockCheckPermission = MockCheckLocationPermissionUseCase();
    mockRequestPermission = MockRequestLocationPermissionUseCase();
    mockCheckService = MockCheckLocationServiceUseCase();
    mockRequestService = MockRequestLocationServiceUseCase();
    mockOpenAppSettings = MockOpenAppSettingsUseCase();
    mockFetchLocation = MockFetchUserCurrentLocationUseCase();
    mockGetAddress = MockGetAddressFromLocationUseCase();
    mockAppConfig = MockAppConfig();

    when(mockAppConfig.mapTilerApiKey).thenReturn('test_key');
  });

  AddAddressViewModel buildViewModel({String apiKey = 'test_key'}) {
    when(mockAppConfig.mapTilerApiKey).thenReturn(apiKey);
    return AddAddressViewModel(
      mockCheckPermission,
      mockRequestPermission,
      mockCheckService,
      mockRequestService,
      mockOpenAppSettings,
      mockFetchLocation,
      mockGetAddress,
      mockAppConfig,
    );
  }

  const tCoordinates = CoordinatesEntity(latitude: 30.0444, longitude: 31.2357);
  const tAddress = '123 Main St';

  group('AddAddressViewModel Initial State', () {
    test('isMapConfigured should be true when mapTilerApiKey is non-empty', () {
      final viewModel = buildViewModel(apiKey: 'valid_api_key');
      expect(viewModel.state.isMapConfigured, isTrue);
      expect(viewModel.mapTilerApiKey, equals('valid_api_key'));
    });

    test('isMapConfigured should be false when mapTilerApiKey is empty', () {
      final viewModel = buildViewModel(apiKey: '');
      expect(viewModel.state.isMapConfigured, isFalse);
    });
  });

  group('CheckLocationPermission Event', () {
    blocTest<AddAddressViewModel, AddAddressState>(
      'emits loading and success(denied) when permission is denied',
      build: () {
        when(
          mockCheckPermission(),
        ).thenAnswer((_) async => PermissionStatusEntity.denied);
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(CheckLocationPermission()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.locationPermission.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
          (s) => s.locationPermission.data,
          'data',
          PermissionStatusEntity.denied,
        ),
      ],
      verify: (_) {
        verify(mockCheckPermission()).called(1);
        verifyZeroInteractions(mockCheckService);
        verifyZeroInteractions(mockFetchLocation);
      },
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'emits permission success and triggers FetchUserLocation when granted and service enabled',
      build: () {
        when(
          mockCheckPermission(),
        ).thenAnswer((_) async => PermissionStatusEntity.granted);
        when(
          mockCheckService(),
        ).thenAnswer((_) async => ServiceStatusEntity.enabled);
        when(mockFetchLocation()).thenAnswer(
          (_) async => SuccessResponse<(CoordinatesEntity, String?)>((
            tCoordinates,
            tAddress,
          )),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(CheckLocationPermission()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.locationPermission.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
          (s) => s.locationPermission.data,
          'data',
          PermissionStatusEntity.granted,
        ),
        isA<AddAddressState>().having(
          (s) => s.userLocation?.isLoading,
          'userLocation.isLoading',
          isTrue,
        ),
        isA<AddAddressState>()
            .having((s) => s.userLocation?.data, 'userLocation.data', tAddress)
            .having(
              (s) => s.selectedLocation,
              'selectedLocation',
              tCoordinates,
            ),
      ],
      verify: (_) {
        verify(mockCheckPermission()).called(1);
        verify(mockCheckService()).called(1);
        verify(mockFetchLocation()).called(1);
      },
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'does not fetch location when permission is granted but service is disabled',
      build: () {
        when(
          mockCheckPermission(),
        ).thenAnswer((_) async => PermissionStatusEntity.granted);
        when(
          mockCheckService(),
        ).thenAnswer((_) async => ServiceStatusEntity.disabled);
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(CheckLocationPermission()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.locationPermission.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
          (s) => s.locationPermission.data,
          'data',
          PermissionStatusEntity.granted,
        ),
      ],
      verify: (_) {
        verify(mockCheckPermission()).called(1);
        verify(mockCheckService()).called(1);
        verifyZeroInteractions(mockFetchLocation);
      },
    );
  });

  group('RequestLocationPermission Event', () {
    blocTest<AddAddressViewModel, AddAddressState>(
      'emits loading and success(granted) and fetches user location',
      build: () {
        when(
          mockRequestPermission(),
        ).thenAnswer((_) async => PermissionStatusEntity.granted);
        when(mockFetchLocation()).thenAnswer(
          (_) async => SuccessResponse<(CoordinatesEntity, String?)>((
            tCoordinates,
            tAddress,
          )),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(RequestLocationPermission()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.locationPermission.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
          (s) => s.locationPermission.data,
          'data',
          PermissionStatusEntity.granted,
        ),
        isA<AddAddressState>().having(
          (s) => s.userLocation?.isLoading,
          'userLocation.isLoading',
          isTrue,
        ),
        isA<AddAddressState>()
            .having((s) => s.userLocation?.data, 'userLocation.data', tAddress)
            .having(
              (s) => s.selectedLocation,
              'selectedLocation',
              tCoordinates,
            ),
      ],
      verify: (_) {
        verify(mockRequestPermission()).called(1);
        verify(mockFetchLocation()).called(1);
      },
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'emits loading and success(denied) without fetching location when denied',
      build: () {
        when(
          mockRequestPermission(),
        ).thenAnswer((_) async => PermissionStatusEntity.denied);
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(RequestLocationPermission()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.locationPermission.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
          (s) => s.locationPermission.data,
          'data',
          PermissionStatusEntity.denied,
        ),
      ],
      verify: (_) {
        verify(mockRequestPermission()).called(1);
        verifyZeroInteractions(mockFetchLocation);
      },
    );
  });

  group('CheckLocationService Event', () {
    blocTest<AddAddressViewModel, AddAddressState>(
      'emits locationEnabled true when service is enabled',
      build: () {
        when(
          mockCheckService(),
        ).thenAnswer((_) async => ServiceStatusEntity.enabled);
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(CheckLocationService()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.locationEnabled,
          'locationEnabled',
          isTrue,
        ),
      ],
      verify: (_) {
        verify(mockCheckService()).called(1);
      },
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'emits locationEnabled false when service is disabled',
      seed: () => AddAddressState.initial().copyWith(locationEnabled: true),
      build: () {
        when(
          mockCheckService(),
        ).thenAnswer((_) async => ServiceStatusEntity.disabled);
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(CheckLocationService()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.locationEnabled,
          'locationEnabled',
          isFalse,
        ),
      ],
      verify: (_) {
        verify(mockCheckService()).called(1);
      },
    );
  });

  group('RequestLocationService Event', () {
    blocTest<AddAddressViewModel, AddAddressState>(
      'emits locationEnabled true and fetches user location when permission is granted',
      seed: () => AddAddressState.initial().copyWith(
        locationPermission: BaseState.success(PermissionStatusEntity.granted),
      ),
      build: () {
        when(mockRequestService()).thenAnswer((_) async => true);
        when(mockFetchLocation()).thenAnswer(
          (_) async => SuccessResponse<(CoordinatesEntity, String?)>((
            tCoordinates,
            tAddress,
          )),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(RequestLocationService()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.locationEnabled,
          'locationEnabled',
          isTrue,
        ),
        isA<AddAddressState>().having(
          (s) => s.userLocation?.isLoading,
          'userLocation.isLoading',
          isTrue,
        ),
        isA<AddAddressState>()
            .having((s) => s.userLocation?.data, 'userLocation.data', tAddress)
            .having(
              (s) => s.selectedLocation,
              'selectedLocation',
              tCoordinates,
            ),
      ],
      verify: (_) {
        verify(mockRequestService()).called(1);
        verify(mockFetchLocation()).called(1);
      },
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'emits locationEnabled true and does not fetch location when permission is not granted',
      seed: () => AddAddressState.initial().copyWith(
        locationPermission: BaseState.success(PermissionStatusEntity.denied),
      ),
      build: () {
        when(mockRequestService()).thenAnswer((_) async => true);
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(RequestLocationService()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.locationEnabled,
          'locationEnabled',
          isTrue,
        ),
      ],
      verify: (_) {
        verify(mockRequestService()).called(1);
        verifyZeroInteractions(mockFetchLocation);
      },
    );
  });

  group('OpenAppSettings Event', () {
    blocTest<AddAddressViewModel, AddAddressState>(
      'emits couldOpenAppSettings result',
      build: () {
        when(mockOpenAppSettings()).thenAnswer((_) async => true);
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(OpenAppSettings()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.couldOpenAppSettings,
          'couldOpenAppSettings',
          isTrue,
        ),
      ],
      verify: (_) {
        verify(mockOpenAppSettings()).called(1);
      },
    );
  });

  group('SelectMapLocation Event', () {
    blocTest<AddAddressViewModel, AddAddressState>(
      'emits loading then success with resolved address',
      build: () {
        when(
          mockGetAddress(tCoordinates),
        ).thenAnswer((_) async => SuccessResponse<String?>(tAddress));
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(SelectMapLocation(tCoordinates)),
      expect: () => [
        isA<AddAddressState>()
            .having((s) => s.selectedLocation, 'selectedLocation', tCoordinates)
            .having(
              (s) => s.userLocation?.isLoading,
              'userLocation.isLoading',
              isTrue,
            ),
        isA<AddAddressState>().having(
          (s) => s.userLocation?.data,
          'userLocation.data',
          tAddress,
        ),
      ],
      verify: (_) {
        verify(mockGetAddress(tCoordinates)).called(1);
      },
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'emits error when address response data is null',
      build: () {
        when(
          mockGetAddress(tCoordinates),
        ).thenAnswer((_) async => SuccessResponse<String?>(null));
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(SelectMapLocation(tCoordinates)),
      expect: () => [
        isA<AddAddressState>()
            .having((s) => s.selectedLocation, 'selectedLocation', tCoordinates)
            .having(
              (s) => s.userLocation?.isLoading,
              'userLocation.isLoading',
              isTrue,
            ),
        isA<AddAddressState>().having(
          (s) => s.userLocation?.errorMessage,
          'userLocation.errorMessage',
          AppStrings.addressNotFoundMessage,
        ),
      ],
      verify: (_) {
        verify(mockGetAddress(tCoordinates)).called(1);
      },
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'emits error when address response is ErrorResponse',
      build: () {
        when(mockGetAddress(tCoordinates)).thenAnswer(
          (_) async => ErrorResponse<String?>('Location lookup error'),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(SelectMapLocation(tCoordinates)),
      expect: () => [
        isA<AddAddressState>()
            .having((s) => s.selectedLocation, 'selectedLocation', tCoordinates)
            .having(
              (s) => s.userLocation?.isLoading,
              'userLocation.isLoading',
              isTrue,
            ),
        isA<AddAddressState>().having(
          (s) => s.userLocation?.errorMessage,
          'userLocation.errorMessage',
          'Location lookup error',
        ),
      ],
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'emits error when address lookup throws an exception',
      build: () {
        when(
          mockGetAddress(tCoordinates),
        ).thenThrow(Exception('Unknown network failure'));
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(SelectMapLocation(tCoordinates)),
      expect: () => [
        isA<AddAddressState>()
            .having((s) => s.selectedLocation, 'selectedLocation', tCoordinates)
            .having(
              (s) => s.userLocation?.isLoading,
              'userLocation.isLoading',
              isTrue,
            ),
        isA<AddAddressState>().having(
          (s) => s.userLocation?.errorMessage,
          'userLocation.errorMessage',
          contains('Unknown network failure'),
        ),
      ],
    );
  });

  group('FetchUserLocation Event', () {
    blocTest<AddAddressViewModel, AddAddressState>(
      'emits loading then success with address and location coordinates',
      build: () {
        when(mockFetchLocation()).thenAnswer(
          (_) async => SuccessResponse<(CoordinatesEntity, String?)>((
            tCoordinates,
            tAddress,
          )),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(FetchUserLocation()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.userLocation?.isLoading,
          'userLocation.isLoading',
          isTrue,
        ),
        isA<AddAddressState>()
            .having((s) => s.userLocation?.data, 'userLocation.data', tAddress)
            .having(
              (s) => s.selectedLocation,
              'selectedLocation',
              tCoordinates,
            ),
      ],
      verify: (_) {
        verify(mockFetchLocation()).called(1);
      },
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'emits error when address is null in response tuple',
      build: () {
        when(mockFetchLocation()).thenAnswer(
          (_) async => SuccessResponse<(CoordinatesEntity, String?)>((
            tCoordinates,
            null,
          )),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(FetchUserLocation()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.userLocation?.isLoading,
          'userLocation.isLoading',
          isTrue,
        ),
        isA<AddAddressState>()
            .having(
              (s) => s.userLocation?.errorMessage,
              'userLocation.errorMessage',
              AppStrings.addressNotFoundMessage,
            )
            .having(
              (s) => s.selectedLocation,
              'selectedLocation',
              tCoordinates,
            ),
      ],
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'emits error when fetch user location returns ErrorResponse',
      build: () {
        when(mockFetchLocation()).thenAnswer(
          (_) async =>
              ErrorResponse<(CoordinatesEntity, String?)>('GPS disabled'),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(FetchUserLocation()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.userLocation?.isLoading,
          'userLocation.isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
          (s) => s.userLocation?.errorMessage,
          'userLocation.errorMessage',
          'GPS disabled',
        ),
      ],
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'emits error when fetch user location throws an exception',
      build: () {
        when(mockFetchLocation()).thenThrow(Exception('Sensor timeout'));
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(FetchUserLocation()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.userLocation?.isLoading,
          'userLocation.isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
          (s) => s.userLocation?.errorMessage,
          'userLocation.errorMessage',
          contains('Sensor timeout'),
        ),
      ],
    );
  });
}
