import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';
import 'package:flowrist/shared/domain/entities/city_entity.dart';
import 'package:flowrist/shared/domain/entities/governorate_entity.dart';

class AddAddressState extends Equatable {
  final BaseState<PermissionStatusEntity> locationPermission;
  final bool locationEnabled;
  final bool? couldOpenAppSettings;
  final BaseState<String>? userLocation;
  final CoordinatesEntity? selectedLocation;
  final bool isMapConfigured;
  final BaseState<List<GovernorateEntity>> governoratesState;
  final BaseState<List<CityEntity>> citiesState;
  final GovernorateEntity? selectedGovernorate;
  final CityEntity? selectedCity;
  final BaseState<bool> saveAddressState;

  const AddAddressState({
    required this.locationPermission,
    required this.locationEnabled,
    this.couldOpenAppSettings,
    required this.userLocation,
    this.selectedLocation,
    this.isMapConfigured = true,
    required this.governoratesState,
    required this.citiesState,
    this.selectedGovernorate,
    this.selectedCity,
    required this.saveAddressState,
  });

  AddAddressState.initial()
    : locationPermission = BaseState.initial(),
      locationEnabled = false,
      couldOpenAppSettings = null,
      userLocation = BaseState.initial(),
      selectedLocation = null,
      isMapConfigured = true,
      governoratesState = BaseState.initial(),
      citiesState = BaseState.initial(),
      selectedGovernorate = null,
      selectedCity = null,
      saveAddressState = BaseState.initial();

  AddAddressState copyWith({
    BaseState<PermissionStatusEntity>? locationPermission,
    bool? locationEnabled,
    bool? couldOpenAppSettings,
    BaseState<String>? userLocation,
    CoordinatesEntity? selectedLocation,
    bool? isMapConfigured,
    BaseState<List<GovernorateEntity>>? governoratesState,
    BaseState<List<CityEntity>>? citiesState,
    GovernorateEntity? selectedGovernorate,
    CityEntity? selectedCity,
    BaseState<bool>? saveAddressState,
  }) {
    return AddAddressState(
      locationPermission: locationPermission ?? this.locationPermission,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      couldOpenAppSettings: couldOpenAppSettings ?? this.couldOpenAppSettings,
      userLocation: userLocation ?? this.userLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      isMapConfigured: isMapConfigured ?? this.isMapConfigured,
      governoratesState: governoratesState ?? this.governoratesState,
      citiesState: citiesState ?? this.citiesState,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      selectedCity: selectedCity ?? this.selectedCity,
      saveAddressState: saveAddressState ?? this.saveAddressState,
    );
  }

  @override
  List<Object?> get props => [
    locationPermission,
    locationEnabled,
    couldOpenAppSettings,
    userLocation,
    selectedLocation,
    isMapConfigured,
    governoratesState,
    citiesState,
    selectedGovernorate,
    selectedCity,
    saveAddressState,
  ];
}
