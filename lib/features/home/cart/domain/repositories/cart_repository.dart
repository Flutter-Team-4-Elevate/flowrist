import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/cart/data/models/request/add_to_cart_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/request/update_cart_item_request_dto.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';

abstract interface class CartRepository {
  Future<BaseResponse<CartEntity>> getCart();
  Future<BaseResponse<void>> addToCart(AddToCartRequestDto request);
  Future<BaseResponse<CartEntity>> updateCartItemQuantity({
    required String itemId,
    required UpdateCartItemRequestDto request,
  });
  Future<BaseResponse<CartEntity>> removeCartItem(String itemId);
}
