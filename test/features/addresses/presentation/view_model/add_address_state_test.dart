import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_state.dart';
import 'package:flowrist/shared/domain/entities/city_entity.dart';
import 'package:flowrist/shared/domain/entities/governorate_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddAddressState Unit Tests', () {
    test('initial state should have correct default values', () {
      final state = AddAddressState.initial();

      expect(state.locationPermission.isLoading, isFalse);
      expect(state.locationPermission.errorMessage, isNull);
      expect(state.locationPermission.data, isNull);

      expect(state.locationEnabled, isFalse);
      expect(state.couldOpenAppSettings, isNull);

      expect(state.userLocation?.isLoading, isFalse);
      expect(state.userLocation?.errorMessage, isNull);
      expect(state.userLocation?.data, isNull);

      expect(state.selectedLocation, isNull);
      expect(state.isMapConfigured, isTrue);

      expect(state.governoratesState.isLoading, isFalse);
      expect(state.governoratesState.data, isNull);

      expect(state.citiesState.isLoading, isFalse);
      expect(state.citiesState.data, isNull);

      expect(state.selectedGovernorate, isNull);
      expect(state.selectedCity, isNull);

      expect(state.saveAddressState.isLoading, isFalse);
      expect(state.saveAddressState.data, isNull);
    });

    test('copyWith should update fields correctly', () {
      final initialState = AddAddressState.initial();

      const newCoordinates = CoordinatesEntity(latitude: 30.0, longitude: 31.0);
      const tGovernorate = GovernorateEntity(id: 1, nameEn: 'Cairo');
      const tCity = CityEntity(id: 1, nameEn: 'Maadi');

      final updatedState = initialState.copyWith(
        locationPermission: BaseState.success(PermissionStatusEntity.granted),
        locationEnabled: true,
        couldOpenAppSettings: true,
        userLocation: BaseState.success('Cairo, Egypt'),
        selectedLocation: newCoordinates,
        isMapConfigured: false,
        governoratesState: BaseState.success([tGovernorate]),
        citiesState: BaseState.success([tCity]),
        selectedGovernorate: tGovernorate,
        selectedCity: tCity,
        saveAddressState: BaseState.success(true),
      );

      expect(updatedState.locationPermission.isLoading, isFalse);
      expect(
        updatedState.locationPermission.data,
        equals(PermissionStatusEntity.granted),
      );
      expect(updatedState.locationEnabled, isTrue);
      expect(updatedState.couldOpenAppSettings, isTrue);
      expect(updatedState.userLocation?.isLoading, isFalse);
      expect(updatedState.userLocation?.data, equals('Cairo, Egypt'));
      expect(updatedState.selectedLocation, equals(newCoordinates));
      expect(updatedState.isMapConfigured, isFalse);
      expect(updatedState.governoratesState.data, equals([tGovernorate]));
      expect(updatedState.citiesState.data, equals([tCity]));
      expect(updatedState.selectedGovernorate, equals(tGovernorate));
      expect(updatedState.selectedCity, equals(tCity));
      expect(updatedState.saveAddressState.data, isTrue);
    });

    test('copyWith with no parameters returns same field values', () {
      final state = AddAddressState.initial();
      final copied = state.copyWith();

      expect(
        copied.locationPermission.isLoading,
        equals(state.locationPermission.isLoading),
      );
      expect(copied.locationEnabled, equals(state.locationEnabled));
      expect(copied.couldOpenAppSettings, equals(state.couldOpenAppSettings));
      expect(copied.selectedLocation, equals(state.selectedLocation));
      expect(copied.isMapConfigured, equals(state.isMapConfigured));
    });

    test('props should contain all relevant fields', () {
      final state = AddAddressState.initial();

      expect(state.props, [
        state.locationPermission,
        state.locationEnabled,
        state.couldOpenAppSettings,
        state.userLocation,
        state.selectedLocation,
        state.isMapConfigured,
        state.governoratesState,
        state.citiesState,
        state.selectedGovernorate,
        state.selectedCity,
        state.saveAddressState,
      ]);
    });
  });
}
