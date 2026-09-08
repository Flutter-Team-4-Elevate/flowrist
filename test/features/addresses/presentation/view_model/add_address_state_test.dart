import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_state.dart';
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
    });

    test('copyWith should update fields correctly', () {
      final initialState = AddAddressState.initial();

      const newCoordinates = CoordinatesEntity(latitude: 30.0, longitude: 31.0);
      final updatedState = initialState.copyWith(
        locationPermission: BaseState.success(PermissionStatusEntity.granted),
        locationEnabled: true,
        couldOpenAppSettings: true,
        userLocation: BaseState.success('Cairo, Egypt'),
        selectedLocation: newCoordinates,
        isMapConfigured: false,
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
      ]);
    });
  });
}
