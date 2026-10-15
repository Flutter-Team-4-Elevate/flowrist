import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PendingCartActionStore {
  AddToCartEvent? _pendingAddToCartEvent;

  void setPendingAction(AddToCartEvent event) {
    _pendingAddToCartEvent = event;
  }

  Future<void> executePendingActionIfAny(CartCubit cartCubit) async {
    final event = _pendingAddToCartEvent;

    if (event == null) {
      return;
    }

    _pendingAddToCartEvent = null;

    await cartCubit.doEvent(event);
  }

  void clear() {
    _pendingAddToCartEvent = null;
  }
}
