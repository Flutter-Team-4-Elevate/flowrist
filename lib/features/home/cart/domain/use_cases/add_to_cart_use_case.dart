import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/cart/data/models/request/add_to_cart_request_dto.dart';
import 'package:flowrist/features/home/cart/domain/repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddToCartUseCase {
  final CartRepository _repository;

  AddToCartUseCase(this._repository);

  Future<BaseResponse<void>> call(AddToCartRequestDto request) async {
    return await _repository.addToCart(request);
  }
}