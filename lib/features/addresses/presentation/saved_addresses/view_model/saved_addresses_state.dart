import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';

class SavedAddressesState extends Equatable {
  final BaseState<List<AddressEntity>> addressesState;
  final BaseState<String?> deleteAddressState;
  final String? deletingAddressId;

  const SavedAddressesState({
    required this.addressesState,
    required this.deleteAddressState,
    this.deletingAddressId,
  });

  factory SavedAddressesState.initial() => const SavedAddressesState(
    addressesState: BaseState.initial(),
    deleteAddressState: BaseState.initial(),
    deletingAddressId: null,
  );

  SavedAddressesState copyWith({
    BaseState<List<AddressEntity>>? addressesState,
    BaseState<String?>? deleteAddressState,
    String? Function()? deletingAddressId,
  }) {
    return SavedAddressesState(
      addressesState: addressesState ?? this.addressesState,
      deleteAddressState: deleteAddressState ?? this.deleteAddressState,
      deletingAddressId: deletingAddressId != null
          ? deletingAddressId()
          : this.deletingAddressId,
    );
  }

  @override
  List<Object?> get props => [
    addressesState,
    deleteAddressState,
    deletingAddressId,
  ];
}
