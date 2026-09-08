import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/categories/domain/entities/category_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';

class CategoriesState extends Equatable {
  final BaseState<List<CategoryEntity>> categories;
  final BaseState<List<ProductEntity>> products;
  final int selectedIndex;

  const CategoriesState({
    required this.categories,
    required this.products,
    required this.selectedIndex,
  });

  CategoriesState.initial()
    : this(
        categories: BaseState.initial(),
        products: BaseState.initial(),
        selectedIndex: 0,
      );

  CategoriesState copyWith({
    BaseState<List<CategoryEntity>>? categories,
    BaseState<List<ProductEntity>>? products,
    int? selectedIndex,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [categories, products, selectedIndex];
}
