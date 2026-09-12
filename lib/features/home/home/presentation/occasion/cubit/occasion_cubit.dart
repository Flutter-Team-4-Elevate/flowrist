import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/occasion_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_occasions_use_case.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_products_use_case.dart';
import 'package:flowrist/features/home/home/presentation/occasion/cubit/occasion_state.dart';
import 'package:flowrist/features/home/home/presentation/occasion/cubit/occassion_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OccasionCubit extends Cubit<OccasionState> {
  final GetOccasionsUseCase _getOccasionsUseCase;
  final GetProductsUseCase _getProductsUseCase;

  OccasionCubit(this._getOccasionsUseCase, this._getProductsUseCase)
    : super(OccasionState.initial());

  Future<void> doEvent(OccasionEvents event) async {
  switch (event) {
    case GetOccasionsEvent():
      await _getOccasions(
        targetOccasionId: event.targetOccasionId,
        initialIndex: event.initialIndex,
      );

    case GetProductsByOccasionEvent():
      await _getProductsByOccasion(event.occasionId);

    case SelectOccasionEvent():
      await _selectOccasion(event.index);
  }
}

Future<void> _getOccasions({String? targetOccasionId, int initialIndex = 0}) async {
    emit(
      state.copyWith(
        occasions: state.occasions.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    final result = await _getOccasionsUseCase();

    switch (result) {
      case SuccessResponse<List<OccasionEntity>>():
        final occasions = result.data ?? [];
        int targetIndex = initialIndex;

        // Find matching index if occasion ID was passed
        if (targetOccasionId != null && occasions.isNotEmpty) {
          final foundIndex = occasions.indexWhere((e) => e.id == targetOccasionId);
          if (foundIndex != -1) {
            targetIndex = foundIndex;
          }
        }

        emit(
          state.copyWith(
            occasions: state.occasions.copyWith(
              isLoading: false,
              errorMessage: null,
              data: occasions,
            ),
            selectedIndex: targetIndex,
          ),
        );

        if (occasions.isNotEmpty && targetIndex < occasions.length) {
          await _getProductsByOccasion(occasions[targetIndex].id);
        }

      case ErrorResponse<List<OccasionEntity>>():
        emit(
          state.copyWith(
            occasions: state.occasions.copyWith(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _getProductsByOccasion(String occasionId) async {
    emit(
      state.copyWith(
        products: state.products.copyWith(isLoading: true, errorMessage: null),
      ),
    );

    final result = await _getProductsUseCase(occasionId: occasionId);

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

  Future<void> _selectOccasion(int index) async {
    final occasions = state.occasions.data;

    if (occasions == null || index < 0 || index >= occasions.length) {
      return;
    }

    final selectedOccasion = occasions[index];

    emit(state.copyWith(selectedIndex: index));

    await _getProductsByOccasion(selectedOccasion.id);
  }
}
