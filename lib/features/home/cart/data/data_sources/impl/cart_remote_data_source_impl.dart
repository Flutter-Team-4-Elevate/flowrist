import 'package:flowrist/features/home/cart/data/client/cart_api_client.dart';
import 'package:flowrist/features/home/cart/data/data_sources/contract/cart_remote_data_source.dart';
import 'package:flowrist/features/home/cart/data/models/request/add_to_cart_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/request/update_cart_item_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/response/cart_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CartRemoteDataSource)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final CartApiClient _apiClient;

  CartRemoteDataSourceImpl(this._apiClient);

  @override
  Future<CartResponseDto> getCart() async {
    return await _apiClient.getCart();
  }

  @override
  Future<dynamic> addToCart(AddToCartRequestDto request) async {
    return await _apiClient.addToCart(request);
  }

  @override
  Future<CartResponseDto> updateCartItemQuantity({
    required String itemId,
    required UpdateCartItemRequestDto request,
  }) async {
    return await _apiClient.updateCartItemQuantity(itemId, request);
  }

  @override
  Future<CartResponseDto> removeCartItem(String itemId) async {
    return await _apiClient.removeCartItem(itemId);
  }
}
