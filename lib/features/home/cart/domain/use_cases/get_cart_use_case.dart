import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/repositories/cart_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCartUseCase {
  final CartRepository _repository;

  GetCartUseCase(this._repository);

  Future<BaseResponse<CartEntity>> call() async {
    return await _repository.getCart();
  }
}