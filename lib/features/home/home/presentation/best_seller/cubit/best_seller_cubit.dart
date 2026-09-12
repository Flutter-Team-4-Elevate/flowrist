import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/presentation/best_seller/cubit/best_seller_events.dart';
import 'package:flowrist/features/home/home/presentation/best_seller/cubit/best_seller_state.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_products_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BestSellerCubit extends Cubit<BestSellerState> {
  final GetProductsUseCase _getProductsUseCase;

  BestSellerCubit(this._getProductsUseCase) : super(BestSellerState.initial());

  Future<void> doEvent(BestSellerEvents event) async {
    switch (event) {
      case GetBestSellerProductsEvent():
        await _getBestSellerProducts(event.categoryId);
    }
  }

  Future<void> _getBestSellerProducts(String categoryId) async {
    emit(
      state.copyWith(
        products: state.products.copyWith(isLoading: true, errorMessage: null),
      ),
    );

    final result = await _getProductsUseCase(categoryId: categoryId);

    switch (result) {
      case SuccessResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            products: state.products.copyWith(
              isLoading: false,
              errorMessage: null,
              data: result.data ?? [],
            ),
          ),
        );

      case ErrorResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            products: state.products.copyWith(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }
}
