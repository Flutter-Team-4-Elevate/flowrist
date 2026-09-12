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
import 'package:flowrist/features/addresses/domain/use_cases/get_cities_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/get_governorates_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/open_app_settings_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/request_location_permission_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/request_location_service_use_case.dart';
import 'package:flowrist/features/addresses/domain/use_cases/save_address_use_case.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_event.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/domain/entities/city_entity.dart';
import '../../../../shared/domain/entities/governorate_entity.dart';
import '../../data/models/add_address_request_model.dart';

@injectable
class AddAddressViewModel extends Cubit<AddAddressState> {
  final CheckLocationPermissionUseCase _checkLocationPermissionUseCase;
  final RequestLocationPermissionUseCase _requestLocationPermissionUseCase;
  final CheckLocationServiceUseCase _checkLocationServiceUseCase;
  final RequestLocationServiceUseCase _requestLocationServiceUseCase;
  final OpenAppSettingsUseCase _openAppSettingsUseCase;
  final FetchUserCurrentLocationUseCase _fetchUserCurrentLocationUseCase;
  final GetAddressFromLocationUseCase _getAddressFromLocationUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final SaveAddressUseCase _saveAddressUseCase;
  final AppConfig _appConfig;

  AddAddressViewModel(
    this._checkLocationPermissionUseCase,
    this._requestLocationPermissionUseCase,
    this._checkLocationServiceUseCase,
    this._requestLocationServiceUseCase,
    this._openAppSettingsUseCase,
    this._fetchUserCurrentLocationUseCase,
    this._getAddressFromLocationUseCase,
    this._getGovernoratesUseCase,
    this._getCitiesUseCase,
    this._saveAddressUseCase,
    this._appConfig,
  ) : super(AddAddressState.initial()) {
    _checkMapConfig();
  }

  void _checkMapConfig() {
    final isConfigured = _appConfig.mapTilerApiKey.isNotEmpty;
    if (!isConfigured) {
      debugPrint(
        'WARNING: MAPTILER_API_KEY is missing. Falling back to OpenStreetMap.',
      );
    }
    emit(state.copyWith(isMapConfigured: isConfigured));
  }

  String get mapTilerApiKey => _appConfig.mapTilerApiKey;

  void doEvent(AddAddressEvent event) {
    switch (event) {
      case CheckLocationPermission():
        _checkLocationPermission();
      case RequestLocationPermission():
        _requestLocationPermission();
      case CheckLocationService():
        _checkLocationService();
      case RequestLocationService():
        _requestLocationService();
      case OpenAppSettings():
        _openAppSettings();
      case FetchUserLocation():
        _fetchUserLocation();
      case SelectMapLocation():
        _selectMapLocation(event.location);
      case GetGovernoratesEvent():
        _loadGovernorates();
      case GetCitiesEvent():
        _loadCities(event.governorateId);
      case SelectGovernorateEvent():
        _selectGovernorate(event.governorate);
      case SelectCityEvent():
        _selectCity(event.city);
      case SaveAddressEvent():
        _saveAddress(event.request);
    }
  }

  void _saveAddress(AddAddressRequestModel request) async {
    emit(state.copyWith(saveAddressState: BaseState.loading()));
    final response = await _saveAddressUseCase(request);
    switch (response) {
      case SuccessResponse<void>():
        emit(state.copyWith(saveAddressState: BaseState.success(true)));

      case ErrorResponse<void>():
        emit(
          state.copyWith(
            saveAddressState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  void _loadGovernorates() async {
    emit(state.copyWith(governoratesState: BaseState.loading()));
    final response = await _getGovernoratesUseCase();
    if (response is SuccessResponse<List<GovernorateEntity>>) {
      if (response.data == null || response.data!.isEmpty) {
        emit(
          state.copyWith(
            governoratesState: BaseState.error(AppStrings.noGovernoratesFound),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          governoratesState: BaseState.success(response.data!),
          selectedGovernorate: response.data![0],
        ),
      );
      _loadCities(response.data![0].id!);
    } else if (response is ErrorResponse<List<GovernorateEntity>>) {
      emit(
        state.copyWith(
          governoratesState: BaseState.error(response.errorMessage),
        ),
      );
    }
  }

  void _loadCities(int governorateId) async {
    emit(state.copyWith(citiesState: BaseState.loading()));
    final response = await _getCitiesUseCase(governorateId);
    if (response is SuccessResponse<List<CityEntity>>) {
      if (response.data == null || response.data!.isEmpty) {
        emit(
          state.copyWith(
            citiesState: BaseState.error(AppStrings.noCitiesFound),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          citiesState: BaseState.success(response.data!),
          selectedCity: response.data![0],
        ),
      );
    } else if (response is ErrorResponse<List<CityEntity>>) {
      emit(state.copyWith(citiesState: BaseState.error(response.errorMessage)));
    }
  }

  void _selectGovernorate(GovernorateEntity governorate) {
    emit(
      state.copyWith(
        selectedGovernorate: governorate,
        selectedCity: null,
        citiesState: BaseState.initial(),
      ),
    );
    if (governorate.id == null) return;
    _loadCities(governorate.id!);
  }

  void _selectCity(CityEntity city) {
    emit(state.copyWith(selectedCity: city));
  }

  void _checkLocationPermission() async {
    emit(state.copyWith(locationPermission: BaseState.loading()));

    final status = await _checkLocationPermissionUseCase();

    if (status == PermissionStatusEntity.granted) {
      final serviceStatus = await _checkLocationServiceUseCase();
      emit(
        state.copyWith(
          locationPermission: BaseState.success(status),
          locationEnabled: serviceStatus == ServiceStatusEntity.enabled,
        ),
      );
      if (serviceStatus == ServiceStatusEntity.enabled) {
        _fetchUserLocation();
      }
    } else {
      emit(state.copyWith(locationPermission: BaseState.success(status)));
    }
  }

  void _requestLocationPermission() async {
    emit(state.copyWith(locationPermission: BaseState.loading()));

    final status = await _requestLocationPermissionUseCase();

    emit(state.copyWith(locationPermission: BaseState.success(status)));

    if (status == PermissionStatusEntity.granted) {
      _fetchUserLocation();
    }
  }

  void _checkLocationService() async {
    final status = await _checkLocationServiceUseCase();

    emit(
      state.copyWith(locationEnabled: status == ServiceStatusEntity.enabled),
    );
  }

  void _requestLocationService() async {
    final status = await _requestLocationServiceUseCase();

    emit(state.copyWith(locationEnabled: status));

    if (status &&
        state.locationPermission.data == PermissionStatusEntity.granted) {
      _fetchUserLocation();
    }
  }

  void _openAppSettings() async {
    final bool couldOpenAppSettings = await _openAppSettingsUseCase();
    emit(state.copyWith(couldOpenAppSettings: couldOpenAppSettings));
  }

  void _selectMapLocation(CoordinatesEntity location) async {
    emit(
      state.copyWith(
        selectedLocation: location,
        userLocation: BaseState.loading(),
      ),
    );

    try {
      final response = await _getAddressFromLocationUseCase(location);

      switch (response) {
        case SuccessResponse<String?>():
          if (response.data == null) {
            emit(
              state.copyWith(
                userLocation: BaseState.error(
                  AppStrings.addressNotFoundMessage,
                ),
              ),
            );
          } else {
            emit(
              state.copyWith(userLocation: BaseState.success(response.data!)),
            );
          }

        case ErrorResponse<String?>():
          emit(
            state.copyWith(
              userLocation: BaseState.error(response.errorMessage),
            ),
          );
      }
    } catch (e) {
      emit(state.copyWith(userLocation: BaseState.error(e.toString())));
    }
  }

  void _fetchUserLocation() async {
    emit(state.copyWith(userLocation: BaseState.loading()));

    try {
      final response = await _fetchUserCurrentLocationUseCase();

      if (response is SuccessResponse<(CoordinatesEntity, String?)>) {
        final data = response.data!;
        final location = data.$1;
        final address = data.$2;
        if (address == null) {
          emit(
            state.copyWith(
              userLocation: BaseState.error(AppStrings.addressNotFoundMessage),
              selectedLocation: location,
            ),
          );
        } else {
          emit(
            state.copyWith(
              userLocation: BaseState.success(address),
              selectedLocation: location,
            ),
          );
        }
      } else if (response is ErrorResponse<(CoordinatesEntity, String?)>) {
        emit(
          state.copyWith(userLocation: BaseState.error(response.errorMessage)),
        );
      }
    } catch (e) {
      emit(state.copyWith(userLocation: BaseState.error(e.toString())));
    }
  }
}
