import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/core/config/app_config.dart';
import 'package:flowrist/core/constants/app_strings.dart';
import 'package:flowrist/features/addresses/data/models/add_address_request_model.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/service_status_entity.dart';
import 'package:flowrist/features/addresses/domain/use_cases/check_location_permission_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/check_location_service_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/fetch_user_current_location_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/get_address_from_location_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/get_cities_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/get_governorates_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/open_app_settings_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/request_location_permission_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/request_location_service_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/save_address_use_case.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_event.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_state.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_view_model.dart';
import 'package:flowrist/shared/domain/entities/city_entity.dart';
import 'package:flowrist/shared/domain/entities/governorate_entity.dart';
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
  GetGovernoratesUseCase,
  GetCitiesUseCase,
  SaveAddressUseCase,
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
  provideDummy<BaseResponse<List<GovernorateEntity>>>(
    SuccessResponse<List<GovernorateEntity>>([]),
  );
  provideDummy<BaseResponse<List<CityEntity>>>(
    SuccessResponse<List<CityEntity>>([]),
  );
  provideDummy<BaseResponse<void>>(SuccessResponse<void>(null));

  late MockCheckLocationPermissionUseCase mockCheckPermission;
  late MockRequestLocationPermissionUseCase mockRequestPermission;
  late MockCheckLocationServiceUseCase mockCheckService;
  late MockRequestLocationServiceUseCase mockRequestService;
  late MockOpenAppSettingsUseCase mockOpenAppSettings;
  late MockFetchUserCurrentLocationUseCase mockFetchLocation;
  late MockGetAddressFromLocationUseCase mockGetAddress;
  late MockGetGovernoratesUseCase mockGetGovernorates;
  late MockGetCitiesUseCase mockGetCities;
  late MockSaveAddressUseCase mockSaveAddress;
  late MockAppConfig mockAppConfig;

  setUp(() {
    mockCheckPermission = MockCheckLocationPermissionUseCase();
    mockRequestPermission = MockRequestLocationPermissionUseCase();
    mockCheckService = MockCheckLocationServiceUseCase();
    mockRequestService = MockRequestLocationServiceUseCase();
    mockOpenAppSettings = MockOpenAppSettingsUseCase();
    mockFetchLocation = MockFetchUserCurrentLocationUseCase();
    mockGetAddress = MockGetAddressFromLocationUseCase();
    mockGetGovernorates = MockGetGovernoratesUseCase();
    mockGetCities = MockGetCitiesUseCase();
    mockSaveAddress = MockSaveAddressUseCase();
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
      mockGetGovernorates,
      mockGetCities,
      mockSaveAddress,
      mockAppConfig,
    );
  }

  const tCoordinates = CoordinatesEntity(latitude: 30.0444, longitude: 31.2357);
  const tAddress = '123 Main St';
  const tGovernorate = GovernorateEntity(
    id: 1,
    nameAr: 'القاهرة',
    nameEn: 'Cairo',
  );
  const tCity = CityEntity(
    id: 1,
    governorateId: 1,
    nameAr: 'المعادي',
    nameEn: 'Maadi',
  );

  final tRequest = AddAddressRequestModel(
    recipientName: 'John Doe',
    recipientPhone: '0123456789',
    addressLine: '123 Main St',
    governorateId: 1,
    cityId: 1,
    area: 'Maadi',
    lat: 30.0444,
    lng: 31.2357,
    label: 'Home',
  );

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

  group('GetGovernoratesEvent Event', () {
    blocTest<AddAddressViewModel, AddAddressState>(
      'emits loading then success with governorates list, selects first, and loads cities',
      build: () {
        when(mockGetGovernorates()).thenAnswer(
          (_) async => SuccessResponse<List<GovernorateEntity>>([tGovernorate]),
        );
        when(mockGetCities(tGovernorate.id!)).thenAnswer(
              (_) async => SuccessResponse<List<CityEntity>>([tCity]),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(GetGovernoratesEvent()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.governoratesState.isLoading,
          'governoratesState.isLoading',
          isTrue,
        ),
        isA<AddAddressState>()
            .having(
              (s) => s.governoratesState.data,
          'governoratesState.data',
          [tGovernorate],
        )
            .having(
              (s) => s.selectedGovernorate,
          'selectedGovernorate',
          tGovernorate,
        ),
        isA<AddAddressState>().having(
              (s) => s.citiesState.isLoading,
          'citiesState.isLoading',
          isTrue,
        ),
        isA<AddAddressState>()
            .having((s) => s.citiesState.data, 'citiesState.data', [tCity])
            .having((s) => s.selectedCity, 'selectedCity', tCity),
      ],
      verify: (_) {
        verify(mockGetGovernorates()).called(1);
        verify(mockGetCities(tGovernorate.id!)).called(1);
      },
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'emits error when governorates lookup fails',
      build: () {
        when(mockGetGovernorates()).thenAnswer(
          (_) async => ErrorResponse<List<GovernorateEntity>>('Server Error'),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(GetGovernoratesEvent()),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.governoratesState.isLoading,
          'governoratesState.isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
          (s) => s.governoratesState.errorMessage,
          'governoratesState.errorMessage',
          'Server Error',
        ),
      ],
    );
  });

  group('GetCitiesEvent Event', () {
    blocTest<AddAddressViewModel, AddAddressState>(
      'emits loading then success with cities list and selects first',
      build: () {
        when(
          mockGetCities(1),
        ).thenAnswer((_) async => SuccessResponse<List<CityEntity>>([tCity]));
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(GetCitiesEvent(1)),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.citiesState.isLoading,
          'citiesState.isLoading',
          isTrue,
        ),
        isA<AddAddressState>()
            .having((s) => s.citiesState.data, 'citiesState.data', [tCity])
            .having((s) => s.selectedCity, 'selectedCity', tCity),
      ],
      verify: (_) {
        verify(mockGetCities(1)).called(1);
      },
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'emits error when cities lookup fails',
      build: () {
        when(mockGetCities(1)).thenAnswer(
          (_) async => ErrorResponse<List<CityEntity>>('Network Error'),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(GetCitiesEvent(1)),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.citiesState.isLoading,
          'citiesState.isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
          (s) => s.citiesState.errorMessage,
          'citiesState.errorMessage',
          'Network Error',
        ),
      ],
    );
  });

  group('SelectGovernorateEvent Event', () {
    blocTest<AddAddressViewModel, AddAddressState>(
      'updates selectedGovernorate, clears selectedCity, and triggers GetCitiesEvent',
      build: () {
        when(
          mockGetCities(tGovernorate.id!),
        ).thenAnswer((_) async => SuccessResponse<List<CityEntity>>([tCity]));
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(SelectGovernorateEvent(tGovernorate)),
      expect: () => [
        isA<AddAddressState>()
            .having(
              (s) => s.selectedGovernorate,
              'selectedGovernorate',
              tGovernorate,
            )
            .having((s) => s.selectedCity, 'selectedCity', isNull),
        isA<AddAddressState>().having(
          (s) => s.citiesState.isLoading,
          'citiesState.isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
          (s) => s.citiesState.data,
          'citiesState.data',
          [tCity],
        ),
      ],
      verify: (_) {
        verify(mockGetCities(tGovernorate.id!)).called(1);
      },
    );
  });

  group('SelectCityEvent Event', () {
    blocTest<AddAddressViewModel, AddAddressState>(
      'updates selectedCity',
      build: () => buildViewModel(),
      act: (cubit) => cubit.doEvent(SelectCityEvent(tCity)),
      expect: () => [
        isA<AddAddressState>().having(
          (s) => s.selectedCity,
          'selectedCity',
          tCity,
        ),
      ],
    );
  });

  group('SaveAddressEvent Event', () {
    blocTest<AddAddressViewModel, AddAddressState>(
      'emits loading then success true when save is successful',
      build: () {
        when(mockSaveAddress(tRequest)).thenAnswer(
              (_) async => SuccessResponse<void>(null),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(SaveAddressEvent(tRequest)),
      expect: () =>
      [
        isA<AddAddressState>().having(
              (s) => s.saveAddressState.isLoading,
          'saveAddressState.isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
              (s) => s.saveAddressState.data,
          'saveAddressState.data',
          isTrue,
        ),
      ],
      verify: (_) {
        verify(mockSaveAddress(tRequest)).called(1);
      },
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'emits error when save fails',
      build: () {
        when(mockSaveAddress(tRequest)).thenAnswer(
              (_) async => ErrorResponse<void>('Failed to save'),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(SaveAddressEvent(tRequest)),
      expect: () =>
      [
        isA<AddAddressState>().having(
              (s) => s.saveAddressState.isLoading,
          'saveAddressState.isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
              (s) => s.saveAddressState.errorMessage,
          'saveAddressState.errorMessage',
          'Failed to save',
        ),
      ],
    );
  });

  group('Governorates and Cities Edge Cases', () {
    blocTest<AddAddressViewModel, AddAddressState>(
      'GetGovernoratesEvent emits error when data is null',
      build: () {
        when(mockGetGovernorates()).thenAnswer(
              (_) async => SuccessResponse<List<GovernorateEntity>>(null),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(GetGovernoratesEvent()),
      expect: () =>
      [
        isA<AddAddressState>().having(
              (s) => s.governoratesState.isLoading,
          'governoratesState.isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
              (s) => s.governoratesState.errorMessage,
          'governoratesState.errorMessage',
          AppStrings.noGovernoratesFound,
        ),
      ],
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'GetCitiesEvent emits error when data is null',
      build: () {
        when(mockGetCities(1)).thenAnswer(
              (_) async => SuccessResponse<List<CityEntity>>(null),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(GetCitiesEvent(1)),
      expect: () =>
      [
        isA<AddAddressState>().having(
              (s) => s.citiesState.isLoading,
          'citiesState.isLoading',
          isTrue,
        ),
        isA<AddAddressState>().having(
              (s) => s.citiesState.errorMessage,
          'citiesState.errorMessage',
          AppStrings.noCitiesFound,
        ),
      ],
    );

    blocTest<AddAddressViewModel, AddAddressState>(
      'SelectGovernorateEvent does not load cities if governorate id is null',
      build: () => buildViewModel(),
      act: (cubit) =>
          cubit.doEvent(
            SelectGovernorateEvent(
                GovernorateEntity(id: null, nameEn: 'Unknown')),
          ),
      expect: () =>
      [
        isA<AddAddressState>()
            .having((s) => s.selectedGovernorate?.id, 'selectedGovernorate.id',
            isNull)
            .having((s) => s.selectedCity, 'selectedCity', isNull),
      ],
      verify: (_) {
        verifyZeroInteractions(mockGetCities);
      },
    );
  });
}
