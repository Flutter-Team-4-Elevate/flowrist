import 'dart:async';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/cart/data/models/request/add_to_cart_request_dto.dart';
import 'package:flowrist/features/home/cart/data/models/request/update_cart_item_request_dto.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_entity.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/remove_cart_item_use_case.dart';
import 'package:flowrist/features/home/cart/domain/use_cases/update_cart_quantity_use_case.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartCubit extends Cubit<CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final UpdateCartQuantityUseCase _updateCartQuantityUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;

  final Map<String, Timer> _quantityTimers = {};

  CartCubit(
    this._getCartUseCase,
    this._addToCartUseCase,
    this._updateCartQuantityUseCase,
    this._removeCartItemUseCase,
  ) : super(CartState.initial());

  Future<void> doEvent(CartEvent event) async {
    switch (event) {
      case GetCartEvent():
        await _getCart();

      case AddToCartEvent():
        await _addToCart(event.productId);

      case ChangeCartQuantityEvent():
        _changeQuantity(
          itemId: event.itemId,
          quantity: event.quantity,
        );

      case RemoveCartItemEvent():
        await _removeCartItem(event.itemId);
    }
  }

  Future<void> _getCart() async {
    emit(
      state.copyWith(
        cart: state.cart.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    final result = await _getCartUseCase();

    switch (result) {
      case SuccessResponse<CartEntity>():
        emit(
          state.copyWith(
            cart: state.cart.copyWith(
              isLoading: false,
              errorMessage: null,
              data: result.data,
            ),
          ),
        );

      case ErrorResponse<CartEntity>():
        emit(
          state.copyWith(
            cart: state.cart.copyWith(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _addToCart(String productId) async {
    final addingProducts = Set<String>.from(
      state.addingProductIds,
    )..add(productId);

    emit(
      state.copyWith(
        addingProductIds: addingProducts,
        cart: state.cart.copyWith(
          errorMessage: null,
        ),
      ),
    );

    final result = await _addToCartUseCase(
      AddToCartRequestDto(
        productId: productId,
        quantity: 1,
      ),
    );

    switch (result) {
      case SuccessResponse<void>():
        final cartResult = await _getCartUseCase();

        switch (cartResult) {
          case SuccessResponse<CartEntity>():
            final updatedAddingProducts = Set<String>.from(
              state.addingProductIds,
            )..remove(productId);

            emit(
              state.copyWith(
                addingProductIds: updatedAddingProducts,
                cart: state.cart.copyWith(
                  isLoading: false,
                  errorMessage: null,
                  data: cartResult.data,
                ),
              ),
            );

          case ErrorResponse<CartEntity>():
            final updatedAddingProducts = Set<String>.from(
              state.addingProductIds,
            )..remove(productId);

            emit(
              state.copyWith(
                addingProductIds: updatedAddingProducts,
                cart: state.cart.copyWith(
                  isLoading: false,
                  errorMessage: cartResult.errorMessage,
                ),
              ),
            );
        }

      case ErrorResponse<void>():
        final updatedAddingProducts = Set<String>.from(
          state.addingProductIds,
        )..remove(productId);

        emit(
          state.copyWith(
            addingProductIds: updatedAddingProducts,
            cart: state.cart.copyWith(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }

  void _changeQuantity({
    required String itemId,
    required int quantity,
  }) {
    final cart = state.cart.data;

    if (cart == null) return;

    final itemIndex = cart.items.indexWhere(
      (item) => item.itemId == itemId,
    );

    if (itemIndex == -1) return;

    final currentItem = cart.items[itemIndex];

    if (quantity > currentItem.availableStock) {
      return;
    }

    _quantityTimers[itemId]?.cancel();

    if (quantity <= 0) {
      _quantityTimers[itemId] = Timer(
        const Duration(milliseconds: 400),
        () async {
          await _removeCartItem(itemId);
        },
      );

      return;
    }

    final updatedItems = List<CartItemEntity>.from(
      cart.items,
    );

    updatedItems[itemIndex] = currentItem.copyWith(
      quantity: quantity,
      lineSubtotal: currentItem.unitPrice * quantity,
    );

    final updatedCart = _calculateCart(
      cart: cart,
      items: updatedItems,
    );

    emit(
      state.copyWith(
        cart: state.cart.copyWith(
          data: updatedCart,
          errorMessage: null,
        ),
      ),
    );

    _quantityTimers[itemId] = Timer(
      const Duration(milliseconds: 400),
      () async {
        final loadingItems = Set<String>.from(
          state.loadingItemIds,
        )..add(itemId);

        emit(
          state.copyWith(
            loadingItemIds: loadingItems,
          ),
        );

        await _updateQuantityOnServer(
          itemId: itemId,
          quantity: quantity,
        );
      },
    );
  }

  Future<void> _updateQuantityOnServer({
    required String itemId,
    required int quantity,
  }) async {
    final result = await _updateCartQuantityUseCase(
      itemId: itemId,
      request: UpdateCartItemRequestDto(
        quantity: quantity,
      ),
    );

    switch (result) {
      case SuccessResponse<CartEntity>():
        final loadingItems = Set<String>.from(
          state.loadingItemIds,
        )..remove(itemId);

        emit(
          state.copyWith(
            loadingItemIds: loadingItems,
            cart: state.cart.copyWith(
              isLoading: false,
              errorMessage: null,
              data: result.data,
            ),
          ),
        );

      case ErrorResponse<CartEntity>():
        await _getCartAfterQuantityError(
          itemId: itemId,
          errorMessage: result.errorMessage,
        );
    }
  }

  Future<void> _removeCartItem(String itemId) async {
    _quantityTimers[itemId]?.cancel();
    _quantityTimers.remove(itemId);

    final loadingItems = Set<String>.from(
      state.loadingItemIds,
    )..add(itemId);

    emit(
      state.copyWith(
        loadingItemIds: loadingItems,
        cart: state.cart.copyWith(
          errorMessage: null,
        ),
      ),
    );

    final result = await _removeCartItemUseCase(itemId);

    switch (result) {
      case SuccessResponse<CartEntity>():
        final updatedLoadingItems = Set<String>.from(
          state.loadingItemIds,
        )..remove(itemId);

        emit(
          state.copyWith(
            loadingItemIds: updatedLoadingItems,
            cart: state.cart.copyWith(
              isLoading: false,
              errorMessage: null,
              data: result.data,
            ),
          ),
        );

      case ErrorResponse<CartEntity>():
        final updatedLoadingItems = Set<String>.from(
          state.loadingItemIds,
        )..remove(itemId);

        emit(
          state.copyWith(
            loadingItemIds: updatedLoadingItems,
            cart: state.cart.copyWith(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _getCartAfterQuantityError({
    required String itemId,
    required String errorMessage,
  }) async {
    final result = await _getCartUseCase();

    final loadingItems = Set<String>.from(
      state.loadingItemIds,
    )..remove(itemId);

    switch (result) {
      case SuccessResponse<CartEntity>():
        emit(
          state.copyWith(
            loadingItemIds: loadingItems,
            cart: state.cart.copyWith(
              isLoading: false,
              errorMessage: errorMessage,
              data: result.data,
            ),
          ),
        );

      case ErrorResponse<CartEntity>():
        emit(
          state.copyWith(
            loadingItemIds: loadingItems,
            cart: state.cart.copyWith(
              isLoading: false,
              errorMessage: errorMessage,
            ),
          ),
        );
    }
  }

  CartEntity _calculateCart({
    required CartEntity cart,
    required List<CartItemEntity> items,
  }) {
    final totalQuantity = items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    final subtotal = items.fold<num>(
      0,
      (sum, item) => sum + (item.unitPrice * item.quantity),
    );

    final deliveryFee = cart.deliveryFee;
    final total = subtotal + deliveryFee;

    return CartEntity(
      cartId: cart.cartId,
      items: items,
      totalQuantity: totalQuantity,
      lineCount: items.length,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      hasChanges: cart.hasChanges,
    );
  }

  @override
  Future<void> close() {
    for (final timer in _quantityTimers.values) {
      timer.cancel();
    }

    _quantityTimers.clear();

    return super.close();
  }
}