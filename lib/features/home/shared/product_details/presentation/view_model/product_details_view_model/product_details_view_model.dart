import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';

import '../../../data/models/product_details_request_dto.dart';
import '../../../domain/use_cases/product_details_use_case.dart';
import '../product_details_event/product_details_event.dart';

@injectable
class ProductDetailsViewModel
    extends Bloc<ProductDetailsEvent, BaseState<ProductDetailsRequestDto>> {
  final GetProductDetailsUseCase getProductDetailsUseCase;

  ProductDetailsViewModel(this.getProductDetailsUseCase)
      : super(BaseState<ProductDetailsRequestDto>.initial()) {
    on<GetProductDetailsEvent>(_getProductDetails);
  }

  Future<void> _getProductDetails(
      GetProductDetailsEvent event,
      Emitter<BaseState<ProductDetailsRequestDto>> emit,
      ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );

    final result = await getProductDetailsUseCase(event.productId);

    switch (result) {
      case SuccessResponse<ProductDetailsRequestDto>():
        emit(
          BaseState(
            isLoading: false,
            errorMessage: null,
            data: result.data,
          ),
        );

      case ErrorResponse<ProductDetailsRequestDto>():
        emit(
          BaseState(
            isLoading: false,
            errorMessage: result.errorMessage,
            data: null,
          ),
        );
    }
  }
}