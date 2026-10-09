sealed class AddressesEvent {}

class InitializeAddress extends AddressesEvent {}

class SetDefaultAddress extends AddressesEvent {
  final String addressId;

  SetDefaultAddress(this.addressId);
}

class RefreshAddresses extends AddressesEvent {
  final String? selectedAddressId;

  RefreshAddresses({this.selectedAddressId});
}
