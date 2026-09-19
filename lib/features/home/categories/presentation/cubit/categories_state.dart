import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/search_and_filtering/filter/models/sort_option.dart';

class CategoriesState extends Equatable {
  final BaseState<List<CategoryEntity>> categories;
  final BaseState<List<ProductEntity>> products;
  final int selectedIndex;
  final SortOption? selectedSort;

  const CategoriesState({
    required this.categories,
    required this.products,
    required this.selectedIndex,
    this.selectedSort,
  });

  CategoriesState.initial()
    : this(
        categories: BaseState.initial(),
        products: BaseState.initial(),
        selectedIndex: 0,
        selectedSort: null,
      );

  CategoriesState copyWith({
    BaseState<List<CategoryEntity>>? categories,
    BaseState<List<ProductEntity>>? products,
    int? selectedIndex,
    SortOption? selectedSort,
    bool clearSort = false,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedSort: clearSort ? null : (selectedSort ?? this.selectedSort),
    );
  }

  @override
  List<Object?> get props => [
    categories,
    products,
    selectedIndex,
    selectedSort,
  ];
}
