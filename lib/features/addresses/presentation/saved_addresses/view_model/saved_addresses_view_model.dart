import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/shared/addresses/domain/use_cases/get_all_user_addresses_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'saved_addresses_event.dart';
import 'saved_addresses_state.dart';

@injectable
class SavedAddressesViewModel extends Cubit<SavedAddressesState> {
  final GetAllUserAddressesUseCase _getAllUserAddressesUseCase;

  SavedAddressesViewModel(this._getAllUserAddressesUseCase)
    : super(SavedAddressesState.initial());

  Future<void> doEvent(SavedAddressesEvent event) async {
    switch (event) {
      case GetSavedAddressesEvent():
        await _getAddresses();
    }
  }

  Future<void> _getAddresses() async {
    emit(state.copyWith(addressesState: BaseState.loading()));

    try {
      final response = await _getAllUserAddressesUseCase();

      switch (response) {
        case SuccessResponse<List<AddressEntity>>():
          emit(
            state.copyWith(
              addressesState: BaseState.success(response.data ?? const []),
            ),
          );

        case ErrorResponse<List<AddressEntity>>():
          emit(
            state.copyWith(
              addressesState: BaseState.error(response.errorMessage),
            ),
          );
      }
    } catch (e) {
      emit(state.copyWith(addressesState: BaseState.error(e.toString())));
    }
  }
}
