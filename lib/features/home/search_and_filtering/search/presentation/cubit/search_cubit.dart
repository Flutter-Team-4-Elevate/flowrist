import 'dart:async';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/search_and_filtering/search/domain/use_cases/search_products_use_case.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/cubit/search_events.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final SearchProductsUseCase _searchProductsUseCase;
  Timer? _debounceTimer;

  SearchCubit(this._searchProductsUseCase) : super(SearchState.initial());

  void doEvent(SearchEvent event) {
    switch (event) {
      case SearchQueryChangedEvent():
        _onQueryChanged(event.query);
      case ClearSearchEvent():
        _onClear();
    }
  }

  void _onQueryChanged(String newQuery) {
    _debounceTimer?.cancel();
    final trimmedQuery = newQuery.trim();

    if (trimmedQuery.isEmpty) {
      emit(
        state.copyWith(
          query: newQuery,
          results: BaseState<List<ProductEntity>>(
            isLoading: false,
            errorMessage: null,
            data: null,
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(query: newQuery));

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _fetchProducts(trimmedQuery);
    });
  }

  Future<void> _fetchProducts(String searchQuery) async {
    emit(
      state.copyWith(
        results: state.results.copyWith(isLoading: true, errorMessage: null),
      ),
    );

    final result = await _searchProductsUseCase(
      query: searchQuery,
      page: 1,
      pageSize: 20,
    );

    if (isClosed || state.query.trim() != searchQuery) return;

    switch (result) {
      case SuccessResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            results: state.results.copyWith(
              isLoading: false,
              errorMessage: null,
              data: result.data ?? <ProductEntity>[],
            ),
          ),
        );

      case ErrorResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            results: state.results.copyWith(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }

  void _onClear() {
    _debounceTimer?.cancel();
    emit(SearchState.initial());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
