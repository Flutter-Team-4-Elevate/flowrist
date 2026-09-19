import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/occasion_entity.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';

class OccasionState extends Equatable {
  final BaseState<List<OccasionEntity>> occasions;
  final BaseState<List<ProductEntity>> products;
  final int selectedIndex;

  const OccasionState({
    required this.occasions,
    required this.products,
    required this.selectedIndex,
  });

  OccasionState.initial()
    : this(
        occasions: BaseState.initial(),
        products: BaseState.initial(),
        selectedIndex: 0,
      );

  OccasionState copyWith({
    BaseState<List<OccasionEntity>>? occasions,
    BaseState<List<ProductEntity>>? products,
    int? selectedIndex,
  }) {
    return OccasionState(
      occasions: occasions ?? this.occasions,
      products: products ?? this.products,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [occasions, products, selectedIndex];
}
