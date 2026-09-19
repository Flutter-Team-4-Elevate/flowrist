import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PendingCartActionStore {
  AddToCartEvent? _pendingAddToCartEvent;

  void setPendingAction(AddToCartEvent event) {
    _pendingAddToCartEvent = event;
  }

  void executePendingActionIfAny(CartCubit cartCubit) {
    if (_pendingAddToCartEvent != null) {
      cartCubit.doEvent(_pendingAddToCartEvent!);
      _pendingAddToCartEvent = null;
    }
  }

  void clear() {
    _pendingAddToCartEvent = null;
  }
}
