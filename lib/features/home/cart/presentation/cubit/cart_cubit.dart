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

  final Map<String, Timer> _debounceTimers = {};

  CartCubit(
    this._getCartUseCase,
    this._addToCartUseCase,
    this._updateCartQuantityUseCase,
    this._removeCartItemUseCase,
  ) : super(const CartState());

  void doIntent(CartEvent event) {
    switch (event) {
      case GetCartEvent():
        _handleGetCart();
      case AddToCartEvent():
        _handleAddToCart(event);
      case ChangeCartQuantityEvent():
        _handleChangeQuantity(event);
      case RemoveCartItemEvent():
        _handleRemoveItem(event);
    }
  }

  Future<void> _handleGetCart() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    final result = await _getCartUseCase();

    switch (result) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            isLoading: false,
            cart: data,
            errorMessage: () => null,
          ),
        );
      case ErrorResponse(:final errorMessage):
        emit(
          state.copyWith(isLoading: false, errorMessage: () => errorMessage),
        );
    }
  }

  Future<void> _handleAddToCart(AddToCartEvent event) async {
    emit(
      state.copyWith(
        loadingProductId: () => event.productId,
        errorMessage: () => null,
      ),
    );

    final result = await _addToCartUseCase(
      AddToCartRequestDto(productId: event.productId, quantity: 1),
    );

    switch (result) {
      case SuccessResponse():
        final syncResult = await _getCartUseCase();
        switch (syncResult) {
          case SuccessResponse(:final data):
            emit(
              state.copyWith(
                loadingProductId: () => null,
                cart: data,
                errorMessage: () => null,
              ),
            );
          case ErrorResponse(:final errorMessage):
            emit(
              state.copyWith(
                loadingProductId: () => null,
                errorMessage: () => errorMessage,
              ),
            );
        }
      case ErrorResponse(:final errorMessage):
        emit(
          state.copyWith(
            loadingProductId: () => null,
            errorMessage: () => errorMessage,
          ),
        );
    }
  }

  void _handleChangeQuantity(ChangeCartQuantityEvent event) {
    final currentItem = state.getItemByProductId(event.productId);
    if (currentItem == null) return;

    final newQuantity = currentItem.quantity + event.delta;
    final currentItems = List<CartItemEntity>.from(state.items);

    List<CartItemEntity> updatedItems;
    if (newQuantity <= 0) {
      updatedItems = currentItems
          .where((item) => item.productId != event.productId)
          .toList();
    } else {
      updatedItems = currentItems.map((item) {
        return item.productId == event.productId
            ? item.copyWith(quantity: newQuantity)
            : item;
      }).toList();
    }

    final optimisticTotal = updatedItems.fold<num>(
      0,
      (sum, item) => sum + (item.unitPrice * item.quantity),
    );

    emit(
      state.copyWith(
        cart: CartEntity(
          cartId: state.cart?.cartId ?? '',
          items: updatedItems,
          total: optimisticTotal,
        ),
        errorMessage: () => null,
      ),
    );

    _debounceTimers[event.productId]?.cancel();

    _debounceTimers[event.productId] = Timer(
      const Duration(milliseconds: 400),
      () async {
        emit(state.copyWith(loadingProductId: () => event.productId));

        if (newQuantity <= 0) {
          final result = await _removeCartItemUseCase(currentItem.itemId);
          _handleApiResult(result);
        } else {
          final result = await _updateCartQuantityUseCase(
            itemId: currentItem.itemId,
            request: UpdateCartItemRequestDto(quantity: newQuantity),
          );
          _handleApiResult(result);
        }
      },
    );
  }

  Future<void> _handleRemoveItem(RemoveCartItemEvent event) async {
    final item = state.items.firstWhere(
      (e) => e.itemId == event.itemId,
      orElse: () => const CartItemEntity(
        itemId: '',
        productId: '',
        productName: '',
        productImage: '',
        unitPrice: 0,
        priceAtAdd: 0,
        quantity: 0,
        availableStock: 0,
      ),
    );

    emit(
      state.copyWith(
        loadingProductId: () =>
            item.productId.isNotEmpty ? item.productId : null,
        errorMessage: () => null,
      ),
    );

    final result = await _removeCartItemUseCase(event.itemId);
    _handleApiResult(result);
  }

  void _handleApiResult(BaseResponse<CartEntity> result) {
    switch (result) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(
            loadingProductId: () => null,
            cart: data,
            errorMessage: () => null,
          ),
        );
      case ErrorResponse(:final errorMessage):
        emit(
          state.copyWith(
            loadingProductId: () => null,
            errorMessage: () => errorMessage,
          ),
        );
    }
  }

  @override
  Future<void> close() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
    return super.close();
  }
}
