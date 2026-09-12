import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';

class BestSellerState extends Equatable {
  final BaseState<List<ProductEntity>> products;

  const BestSellerState({required this.products});

  BestSellerState.initial() : this(products: BaseState.initial());

  BestSellerState copyWith({BaseState<List<ProductEntity>>? products}) {
    return BestSellerState(products: products ?? this.products);
  }

  @override
  List<Object?> get props => [products];
}
