import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';

class SearchState extends Equatable {
  final String query;
  final BaseState<List<ProductEntity>> results;

  const SearchState({required this.query, required this.results});

  factory SearchState.initial() {
    return SearchState(
      query: '',
      results: BaseState<List<ProductEntity>>(
        isLoading: false,
        errorMessage: null,
        data: null,
      ),
    );
  }

  SearchState copyWith({
    String? query,
    BaseState<List<ProductEntity>>? results,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [query, results];
}
