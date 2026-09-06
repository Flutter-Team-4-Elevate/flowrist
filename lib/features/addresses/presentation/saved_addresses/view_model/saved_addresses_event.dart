sealed class SavedAddressesEvent {}

class GetSavedAddressesEvent extends SavedAddressesEvent {}

class DeleteAddressEvent extends SavedAddressesEvent {
  final String addressId;

  DeleteAddressEvent(this.addressId);
}
