import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/cart/data/models/request/update_cart_item_request_dto.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateCartQuantityUseCase {
  final CartRepository _repository;

  UpdateCartQuantityUseCase(this._repository);

  Future<BaseResponse<CartEntity>> call({
    required String itemId,
    required UpdateCartItemRequestDto request,
  }) async {
    return await _repository.updateCartItemQuantity(
      itemId: itemId,
      request: request,
    );
  }
}
