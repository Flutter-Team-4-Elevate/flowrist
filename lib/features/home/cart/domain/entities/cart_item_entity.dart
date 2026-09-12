import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String itemId;
  final String productId;
  final String productName;
  final String productImage;
  final num unitPrice;
  final num priceAtAdd;
  final int quantity;
  final num lineSubtotal;
  final int availableStock;
  final bool isAvailable;
  final bool priceChanged;
  final bool stockChanged;

  const CartItemEntity({
    required this.itemId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.unitPrice,
    required this.priceAtAdd,
    required this.quantity,
    required this.lineSubtotal,
    required this.availableStock,
    required this.isAvailable,
    required this.priceChanged,
    required this.stockChanged,
  });

  CartItemEntity copyWith({
    String? itemId,
    String? productId,
    String? productName,
    String? productImage,
    num? unitPrice,
    num? priceAtAdd,
    int? quantity,
    num? lineSubtotal,
    int? availableStock,
    bool? isAvailable,
    bool? priceChanged,
    bool? stockChanged,
  }) {
    return CartItemEntity(
      itemId: itemId ?? this.itemId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      unitPrice: unitPrice ?? this.unitPrice,
      priceAtAdd: priceAtAdd ?? this.priceAtAdd,
      quantity: quantity ?? this.quantity,
      lineSubtotal: lineSubtotal ?? this.lineSubtotal,
      availableStock: availableStock ?? this.availableStock,
      isAvailable: isAvailable ?? this.isAvailable,
      priceChanged: priceChanged ?? this.priceChanged,
      stockChanged: stockChanged ?? this.stockChanged,
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
    lineSubtotal,
    availableStock,
    isAvailable,
    priceChanged,
    stockChanged,
  ];
}
