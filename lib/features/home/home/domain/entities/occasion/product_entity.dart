import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final double? discountPercentage;
  final double? discountPrice;
  final bool inStock;
  final String categoryId;
  final String categoryName;
  final String imageUrl;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    this.discountPercentage,
    this.discountPrice,
    required this.inStock,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    discountPercentage,
    discountPrice,
    inStock,
    categoryId,
    categoryName,
    imageUrl,
  ];
}
