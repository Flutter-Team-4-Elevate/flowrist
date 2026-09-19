import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/helpers/pending_cart_action_store.dart';

@GenerateNiceMocks([MockSpec<CartCubit>()])
import 'pending_cart_action_store_test.mocks.dart';

void main() {
  late PendingCartActionStore store;
  late MockCartCubit mockCartCubit;

  setUp(() {
    store = PendingCartActionStore();
    mockCartCubit = MockCartCubit();
  });

  group('PendingCartActionStore Tests', () {
    test('executes and clears pending action when present', () {
      final event = AddToCartEvent(productId: 'prod_123');
      store.setPendingAction(event);

      store.executePendingActionIfAny(mockCartCubit);

      verify(mockCartCubit.doEvent(event)).called(1);

      store.executePendingActionIfAny(mockCartCubit);
      verifyNever(mockCartCubit.doEvent(any));
    });

    test('clear resets pending action', () {
      store.setPendingAction(AddToCartEvent(productId: 'prod_123'));
      store.clear();

      store.executePendingActionIfAny(mockCartCubit);
      verifyNever(mockCartCubit.doEvent(any));
    });
  });
}
