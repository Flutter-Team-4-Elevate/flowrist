import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/shared/addresses/domain/use_cases/delete_address_use_case.dart';
import 'package:flowrist/shared/addresses/domain/use_cases/get_all_user_addresses_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'saved_addresses_event.dart';
import 'saved_addresses_state.dart';

@injectable
class SavedAddressesViewModel extends Cubit<SavedAddressesState> {
  final GetAllUserAddressesUseCase _getAllUserAddressesUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;

  SavedAddressesViewModel(this._getAllUserAddressesUseCase,
      this._deleteAddressUseCase,) : super(SavedAddressesState.initial());

  Future<void> doEvent(SavedAddressesEvent event) async {
    switch (event) {
      case GetSavedAddressesEvent():
        await _getAddresses();
      case DeleteAddressEvent():
        await _deleteAddress(event.addressId);
    }
  }

  Future<void> _getAddresses() async {
    emit(
      state.copyWith(
        addressesState: state.addressesState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    try {
      final response = await _getAllUserAddressesUseCase();

      switch (response) {
        case SuccessResponse<List<AddressEntity>>():
          emit(
            state.copyWith(
              addressesState: BaseState<List<AddressEntity>>.success(
                response.data ?? const [],
              ),
            ),
          );

        case ErrorResponse<List<AddressEntity>>():
          emit(
            state.copyWith(
              addressesState: BaseState<List<AddressEntity>>.error(
                response.errorMessage,
              ),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          addressesState: BaseState<List<AddressEntity>>.error(
            e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    emit(
      state.copyWith(
        deletingAddressId: () => addressId,
        deleteAddressState: BaseState<String?>.loading(),
      ),
    );

    try {
      final response = await _deleteAddressUseCase(addressId);

      switch (response) {
        case SuccessResponse<String>():
          final updatedList = (state.addressesState.data ?? [])
              .where((address) => address.id != addressId)
              .toList();

          emit(
            state.copyWith(
              deletingAddressId: () => null,
              deleteAddressState: BaseState<String?>.success(response.data),
              addressesState: state.addressesState.copyWith(
                data: updatedList,
              ),
            ),
          );

        case ErrorResponse<String>():
          emit(
            state.copyWith(
              deletingAddressId: () => null,
              deleteAddressState: BaseState<String?>.error(
                  response.errorMessage),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          deletingAddressId: () => null,
          deleteAddressState: BaseState<String?>.error(e.toString()),
        ),
      );
    }
  }
}
