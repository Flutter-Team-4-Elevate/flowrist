import 'package:flowrist/config/api_error_handler/api_error_handler.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/cart/data/data_sources/contract/cart_remote_data_source.dart';
import 'package:flowrist/features/home/cart/data/mapper/cart_mapper.dart';
import 'package:flowrist/features/home/cart/data/models/request/add_to_cart_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/request/update_cart_item_request_dto.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;

  CartRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<CartEntity>> getCart() async {
    try {
      final responseDto = await _remoteDataSource.getCart();
      final entity = CartMapper.toCartEntity(responseDto);
      return SuccessResponse<CartEntity>(entity);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<CartEntity>(e);
    }
  }

  @override
  Future<BaseResponse<void>> addToCart(AddToCartRequestDto request) async {
    try {
      await _remoteDataSource.addToCart(request);
      return SuccessResponse<void>(null);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<void>(e);
    }
  }

  @override
  Future<BaseResponse<CartEntity>> updateCartItemQuantity({
    required String itemId,
    required UpdateCartItemRequestDto request,
  }) async {
    try {
      final responseDto = await _remoteDataSource.updateCartItemQuantity(
        itemId: itemId,
        request: request,
      );
      final entity = CartMapper.toCartEntity(responseDto);
      return SuccessResponse<CartEntity>(entity);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<CartEntity>(e);
    }
  }

  @override
  Future<BaseResponse<CartEntity>> removeCartItem(String itemId) async {
    try {
      final responseDto = await _remoteDataSource.removeCartItem(itemId);
      final entity = CartMapper.toCartEntity(responseDto);
      return SuccessResponse<CartEntity>(entity);
    } on Exception catch (e) {
      return ApiErrorHandler.handleException<CartEntity>(e);
    }
  }
}
