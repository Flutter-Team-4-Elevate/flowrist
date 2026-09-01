import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';

class SavedAddressesState extends Equatable {
  final BaseState<List<AddressEntity>> addressesState;

  const SavedAddressesState({required this.addressesState});

  factory SavedAddressesState.initial() =>
      const SavedAddressesState(addressesState: BaseState.initial());

  SavedAddressesState copyWith({
    BaseState<List<AddressEntity>>? addressesState,
  }) {
    return SavedAddressesState(
      addressesState: addressesState ?? this.addressesState,
    );
  }

  @override
  List<Object?> get props => [addressesState];
}
