import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/shared/addresses/domain/entities/default_address_entity.dart';

class AddressesState {
  final BaseState<List<AddressEntity>> addressesState;
  final BaseState<DefaultAddressEntity> setDefaultAddressState;
  final AddressEntity? selectedAddress;

  AddressesState({
    required this.addressesState,
    required this.setDefaultAddressState,
    this.selectedAddress,
  });

  AddressesState copyWith({
    BaseState<List<AddressEntity>>? addressesState,
    BaseState<DefaultAddressEntity>? setDefaultAddressState,
    AddressEntity? selectedAddress,
    bool clearSelectedAddress = false,
  }) {
    return AddressesState(
      addressesState:
          addressesState ?? this.addressesState,
      setDefaultAddressState:
          setDefaultAddressState ??
              this.setDefaultAddressState,
      selectedAddress: clearSelectedAddress
          ? null
          : selectedAddress ?? this.selectedAddress,
    );
  }
}