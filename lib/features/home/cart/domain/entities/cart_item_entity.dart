import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String itemId;
  final String productId;
  final String productName;
  final String productImage;
  final num unitPrice;
  final num priceAtAdd;
  final int quantity;
  final int availableStock;

  const CartItemEntity({
    required this.itemId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.unitPrice,
    required this.priceAtAdd,
    required this.quantity,
    required this.availableStock,
  });

  CartItemEntity copyWith({
    String? itemId,
    String? productId,
    String? productName,
    String? productImage,
    num? unitPrice,
    num? priceAtAdd,
    int? quantity,
    int? availableStock,
  }) {
    return CartItemEntity(
      itemId: itemId ?? this.itemId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      unitPrice: unitPrice ?? this.unitPrice,
      priceAtAdd: priceAtAdd ?? this.priceAtAdd,
      quantity: quantity ?? this.quantity,
      availableStock: availableStock ?? this.availableStock,
    );
  }

  @override
  List<Object?> get props => [
    itemId,
    productId,
    productName,
    productImage,
    unitPrice,
    priceAtAdd,
    quantity,
    availableStock,
  ];
}
