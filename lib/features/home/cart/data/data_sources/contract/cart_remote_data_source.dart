import 'package:flowrist/features/home/cart/data/models/request/add_to_cart_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/request/update_cart_item_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/response/cart_response_dto.dart';

abstract interface class CartRemoteDataSource {
  Future<CartResponseDto> getCart();
  Future<dynamic> addToCart(AddToCartRequestDto request);
  Future<CartResponseDto> updateCartItemQuantity({
    required String itemId,
    required UpdateCartItemRequestDto request,
  });
  Future<CartResponseDto> removeCartItem(String itemId);
}
