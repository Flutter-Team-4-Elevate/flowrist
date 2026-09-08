import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';
import 'package:flowrist/features/home/categories/domain/use_cases/get_categories_use_case.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_events.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_state.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_products_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetProductsUseCase _getProductsUseCase;

  CategoriesCubit(this._getCategoriesUseCase, this._getProductsUseCase)
    : super(CategoriesState.initial());

  Future<void> doEvent(CategoriesEvents event) async {
    switch (event) {
      case GetCategoriesEvent():
        await _getCategories(
          targetCategoryId: event.targetCategoryId,
          initialIndex: event.initialIndex,
        );

      case GetProductsByCategoryEvent():
        await _getProductsByCategory(event.categoryId);

      case SelectCategoryEvent():
        await _selectCategory(event.index);
    }
  }

  Future<void> _getCategories({
    String? targetCategoryId,
    int initialIndex = 0,
  }) async {
    emit(
      state.copyWith(
        categories: state.categories.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    final result = await _getCategoriesUseCase();

    switch (result) {
      case SuccessResponse<List<CategoryEntity>>():
        final categories = result.data ?? [];

        if (categories.isEmpty) {
          emit(
            state.copyWith(
              categories: state.categories.copyWith(
                isLoading: false,
                errorMessage: null,
                data: [],
              ),
              selectedIndex: 0,
            ),
          );
          return;
        }

        int targetIndex = initialIndex;

        // Make sure the initial index is valid.
        if (targetIndex < 0 || targetIndex >= categories.length) {
          targetIndex = 0;
        }

        // If Home passed a category ID,
        // find its position in the Categories API response.
        if (targetCategoryId != null) {
          final foundIndex = categories.indexWhere(
            (category) => category.id == targetCategoryId,
          );

          if (foundIndex != -1) {
            targetIndex = foundIndex;
          }
        }

        emit(
          state.copyWith(
            categories: state.categories.copyWith(
              isLoading: false,
              errorMessage: null,
              data: categories,
            ),
            selectedIndex: targetIndex,
          ),
        );

        // Load products for the selected category.
        await _getProductsByCategory(categories[targetIndex].id);

      case ErrorResponse<List<CategoryEntity>>():
        emit(
          state.copyWith(
            categories: state.categories.copyWith(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _getProductsByCategory(String categoryId) async {
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

  Future<void> _selectCategory(int index) async {
    final categories = state.categories.data;

    if (categories == null || index < 0 || index >= categories.length) {
      return;
    }

    final selectedCategory = categories[index];

    emit(state.copyWith(selectedIndex: index));

    await _getProductsByCategory(selectedCategory.id);
  }
}
