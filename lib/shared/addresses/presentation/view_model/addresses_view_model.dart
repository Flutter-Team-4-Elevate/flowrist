import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/addresses/domain/entities/coordinates_entity.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/shared/addresses/domain/entities/default_address_entity.dart';
import 'package:flowrist/shared/addresses/domain/use_cases/get_all_user_addresses_use_case.dart';
import 'package:flowrist/shared/addresses/domain/use_cases/get_user_current_location_use_case.dart';
import 'package:flowrist/shared/addresses/domain/use_cases/set_default_address_use_case.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_event.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddressesViewModel extends Cubit<AddressesState> {
  final GetAllUserAddressesUseCase _getAllUserAddressesUseCase;
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;
  final GetUserCurrentLocationUseCase _getUserCurrentLocationUseCase;

  AddressesViewModel(
    this._getAllUserAddressesUseCase,
    this._setDefaultAddressUseCase,
    this._getUserCurrentLocationUseCase,
  ) : super(
          AddressesState(
            addressesState: BaseState.initial(),
            setDefaultAddressState: BaseState.initial(),
          ),
        );

  Future<void> doEvent(AddressesEvent event) async {
    switch (event) {
      case InitializeAddress():
        await _initializeAddress();

      case SetDefaultAddress():
        await _setDefaultAddress(event.addressId);

      case RefreshAddresses():
        await _refreshAddresses(event.selectedAddressId);
    }
  }

  Future<void> _initializeAddress() async {
    emit(
      state.copyWith(
        addressesState: state.addressesState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    try {
      CoordinatesEntity? position;

      try {
        final response = await _getUserCurrentLocationUseCase();
        final data = (response as SuccessResponse).data!;
        position = data.$1;
      } catch (e) {
        debugPrint('LOCATION NOT AVAILABLE: $e');
      }

      final response = await _getAllUserAddressesUseCase();

      switch (response) {
        case SuccessResponse<List<AddressEntity>>():
          final addresses = response.data ?? [];

          if (addresses.isEmpty) {
            emit(
              state.copyWith(
                addressesState: state.addressesState.copyWith(
                  data: const [],
                  isLoading: false,
                  errorMessage: null,
                ),
                clearSelectedAddress: true,
              ),
            );

            return;
          }

          AddressEntity? nearestAddress;

          if (position != null) {
            nearestAddress = _findNearestAddress(
              addresses,
              position,
            );
          }

          nearestAddress ??= _findDefaultAddress(addresses);
          nearestAddress ??= addresses.first;

          if (position != null) {
            final currentDefault = _findDefaultAddress(addresses);

            if (currentDefault?.id != nearestAddress.id) {
              await _makeAddressDefault(
                nearestAddress,
                addresses,
              );

              return;
            }
          }

          emit(
            state.copyWith(
              addressesState: state.addressesState.copyWith(
                data: addresses,
                isLoading: false,
                errorMessage: null,
              ),
              selectedAddress: nearestAddress,
            ),
          );

        case ErrorResponse<List<AddressEntity>>():
          emit(
            state.copyWith(
              addressesState: state.addressesState.copyWith(
                data: const [],
                isLoading: false,
                errorMessage: response.errorMessage,
              ),
              clearSelectedAddress: true,
            ),
          );
      }
    } catch (e, stackTrace) {
      debugPrint(stackTrace.toString());

      emit(
        state.copyWith(
          addressesState: state.addressesState.copyWith(
            data: const [],
            isLoading: false,
            errorMessage: e.toString(),
          ),
          clearSelectedAddress: true,
        ),
      );
    }
  }

  Future<void> _refreshAddresses(String? selectedAddressId) async {
    emit(
      state.copyWith(
        addressesState: state.addressesState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    try {
      final oldAddressIds = (state.addressesState.data ?? [])
          .map((address) => address.id)
          .toSet();

      final response = await _getAllUserAddressesUseCase();

      switch (response) {
        case SuccessResponse<List<AddressEntity>>():
          final addresses = response.data ?? [];

          if (addresses.isEmpty) {
            emit(
              state.copyWith(
                addressesState: state.addressesState.copyWith(
                  data: const [],
                  isLoading: false,
                  errorMessage: null,
                ),
                clearSelectedAddress: true,
              ),
            );

            return;
          }

          AddressEntity? newlyAddedAddress;

          for (final address in addresses) {
            if (!oldAddressIds.contains(address.id)) {
              newlyAddedAddress = address;
              break;
            }
          }

          AddressEntity? selectedAddress;

          if (newlyAddedAddress != null) {
            selectedAddress = newlyAddedAddress;
          }

          if (selectedAddress == null &&
              state.selectedAddress?.id != null) {
            selectedAddress = _findAddressById(
              addresses,
              state.selectedAddress!.id,
            );
          }

          if (selectedAddress == null && selectedAddressId != null) {
            selectedAddress = _findAddressById(
              addresses,
              selectedAddressId,
            );
          }

          selectedAddress ??= _findDefaultAddress(addresses);
          selectedAddress ??= addresses.first;

          emit(
            state.copyWith(
              addressesState: state.addressesState.copyWith(
                data: addresses,
                isLoading: false,
                errorMessage: null,
              ),
              selectedAddress: selectedAddress,
            ),
          );

          if (newlyAddedAddress != null &&
              !newlyAddedAddress.isDefault) {
            await _setNewAddressAsDefault(newlyAddedAddress);
          }

        case ErrorResponse<List<AddressEntity>>():
          emit(
            state.copyWith(
              addressesState: state.addressesState.copyWith(
                isLoading: false,
                errorMessage: response.errorMessage,
              ),
            ),
          );
      }
    } catch (e, stackTrace) {
    debugPrint(stackTrace.toString());


      emit(
        state.copyWith(
          addressesState: state.addressesState.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  AddressEntity? _findAddressById(
    List<AddressEntity> addresses,
    String id,
  ) {
    for (final address in addresses) {
      if (address.id == id) {
        return address;
      }
    }

    return null;
  }

  Future<void> _makeAddressDefault(
    AddressEntity nearestAddress,
    List<AddressEntity> addresses,
  ) async {
    emit(
      state.copyWith(
        addressesState: state.addressesState.copyWith(
          data: addresses,
          isLoading: true,
          errorMessage: null,
        ),
        selectedAddress: nearestAddress,
      ),
    );

    try {
      final response = await _setDefaultAddressUseCase(
        nearestAddress.id,
      );

      switch (response) {
        case SuccessResponse<DefaultAddressEntity>():
          final defaultAddress = response.data;

          if (defaultAddress == null) {
            emit(
              state.copyWith(
                addressesState: state.addressesState.copyWith(
                  data: addresses,
                  isLoading: false,
                  errorMessage: null,
                ),
                selectedAddress: nearestAddress,
              ),
            );

            return;
          }

          await _refreshAddressesAfterDefault(defaultAddress);

        case ErrorResponse<DefaultAddressEntity>():
          emit(
            state.copyWith(
              addressesState: state.addressesState.copyWith(
                data: addresses,
                isLoading: false,
                errorMessage: null,
              ),
              selectedAddress: nearestAddress,
              setDefaultAddressState:
                  state.setDefaultAddressState.copyWith(
                isLoading: false,
                errorMessage: response.errorMessage,
              ),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          addressesState: state.addressesState.copyWith(
            data: addresses,
            isLoading: false,
            errorMessage: null,
          ),
          selectedAddress: nearestAddress,
          setDefaultAddressState:
              state.setDefaultAddressState.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _setNewAddressAsDefault(
    AddressEntity newAddress,
  ) async {
    emit(
      state.copyWith(
        selectedAddress: newAddress,
        setDefaultAddressState:
            state.setDefaultAddressState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    try {
      final response = await _setDefaultAddressUseCase(
        newAddress.id,
      );

      switch (response) {
        case SuccessResponse<DefaultAddressEntity>():
          final defaultAddress = response.data;

          if (defaultAddress == null) {
            emit(
              state.copyWith(
                selectedAddress: newAddress,
                setDefaultAddressState:
                    state.setDefaultAddressState.copyWith(
                  isLoading: false,
                  errorMessage:
                      'Default address response is empty.',
                ),
              ),
            );

            return;
          }

          await _refreshAddressesAfterDefault(
            defaultAddress,
          );

        case ErrorResponse<DefaultAddressEntity>():
          emit(
            state.copyWith(
              selectedAddress: newAddress,
              setDefaultAddressState:
                  state.setDefaultAddressState.copyWith(
                isLoading: false,
                errorMessage: response.errorMessage,
              ),
            ),
          );
      }
    } catch (e, stackTrace) {
    debugPrint(stackTrace.toString());

      emit(
        state.copyWith(
          selectedAddress: newAddress,
          setDefaultAddressState:
              state.setDefaultAddressState.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  AddressEntity? _findNearestAddress(
    List<AddressEntity> addresses,
    CoordinatesEntity position,
  ) {
    if (addresses.isEmpty) {
      return null;
    }

    AddressEntity? nearestAddress;
    double shortestDistance = double.infinity;

    for (final address in addresses) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        address.lat,
        address.lng,
      );

      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestAddress = address;
      }
    }

    return nearestAddress;
  }

  AddressEntity? _findDefaultAddress(
    List<AddressEntity> addresses,
  ) {
    for (final address in addresses) {
      if (address.isDefault) {
        return address;
      }
    }

    return null;
  }

  void selectAddress(AddressEntity address) {
    emit(
      state.copyWith(
        selectedAddress: address,
      ),
    );
  }

  Future<void> _setDefaultAddress(
    String addressId,
  ) async {
    emit(
      state.copyWith(
        setDefaultAddressState:
            state.setDefaultAddressState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    try {
      final response = await _setDefaultAddressUseCase(
        addressId,
      );

      switch (response) {
        case SuccessResponse<DefaultAddressEntity>():
          final defaultAddress = response.data;

          if (defaultAddress == null) {
            emit(
              state.copyWith(
                setDefaultAddressState:
                    state.setDefaultAddressState.copyWith(
                  isLoading: false,
                  errorMessage:
                      'Default address response is empty.',
                ),
              ),
            );

            return;
          }

          await _refreshAddressesAfterDefault(
            defaultAddress,
          );

        case ErrorResponse<DefaultAddressEntity>():
          emit(
            state.copyWith(
              setDefaultAddressState:
                  state.setDefaultAddressState.copyWith(
                isLoading: false,
                errorMessage: response.errorMessage,
              ),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          setDefaultAddressState:
              state.setDefaultAddressState.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _refreshAddressesAfterDefault(
    DefaultAddressEntity defaultAddress,
  ) async {
    final response = await _getAllUserAddressesUseCase();

    switch (response) {
      case SuccessResponse<List<AddressEntity>>():
        final addresses = response.data ?? [];

        if (addresses.isEmpty) {
          emit(
            state.copyWith(
              addressesState: state.addressesState.copyWith(
                data: const [],
                isLoading: false,
                errorMessage: null,
              ),
              clearSelectedAddress: true,
              setDefaultAddressState:
                  state.setDefaultAddressState.copyWith(
                data: defaultAddress,
                isLoading: false,
                errorMessage: null,
              ),
            ),
          );

          return;
        }

        AddressEntity? selectedAddress;

        for (final address in addresses) {
          if (address.id == defaultAddress.addressId) {
            selectedAddress = address;
            break;
          }
        }

        selectedAddress ??= _findDefaultAddress(addresses);
        selectedAddress ??= addresses.first;

        emit(
          state.copyWith(
            addressesState: state.addressesState.copyWith(
              data: addresses,
              isLoading: false,
              errorMessage: null,
            ),
            selectedAddress: selectedAddress,
            setDefaultAddressState:
                state.setDefaultAddressState.copyWith(
              data: defaultAddress,
              isLoading: false,
              errorMessage: null,
            ),
          ),
        );

      case ErrorResponse<List<AddressEntity>>():
        emit(
          state.copyWith(
            addressesState: state.addressesState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
            setDefaultAddressState:
                state.setDefaultAddressState.copyWith(
              data: defaultAddress,
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}