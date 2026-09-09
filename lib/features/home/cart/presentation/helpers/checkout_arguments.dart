
import 'package:equatable/equatable.dart';

class CheckoutArguments extends Equatable {
  final String cartId;
  final String addressId;
  final double subTotal;

  const CheckoutArguments({required this.cartId, required this.addressId, required this.subTotal});

  @override
  List<Object?> get props => [cartId, addressId];
}