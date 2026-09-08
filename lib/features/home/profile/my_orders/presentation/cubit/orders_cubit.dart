import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/use_cases/get_order_details_use_case.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/use_cases/get_orders_use_case.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_events.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase _getOrdersUseCase;
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;

  OrdersCubit(this._getOrdersUseCase, this._getOrderDetailsUseCase)
    : super(const OrdersState());

  void doEvent(OrdersEvents event) {
    switch (event) {
      case LoadOrdersEvent():
        _loadOrders(event.page, event.pageSize);
      case LoadMoreOrdersEvent():
        _loadMoreOrders();
      case LoadOrderDetailsEvent():
        _loadOrderDetails(event.orderId);
    }
  }

  Future<void> _loadOrders(int page, int pageSize) async {
    emit(
      state.copyWith(
        orders: state.orders.copyWith(isLoading: true, errorMessage: null),
        currentPage: 1,
        pageSize: pageSize,
        hasNextPage: true,
      ),
    );

    final response = await _getOrdersUseCase.call(
      page: page,
      pageSize: pageSize,
    );

    switch (response) {
      case SuccessResponse(data: final result):
        emit(
          state.copyWith(
            orders: state.orders.copyWith(
              isLoading: false,
              data: result?.orders ?? [],
              errorMessage: null,
            ),
            currentPage: result?.currentPage ?? 1,
            hasNextPage: result?.hasNextPage ?? false,
          ),
        );
      case ErrorResponse(errorMessage: final message):
        emit(
          state.copyWith(
            orders: state.orders.copyWith(
              isLoading: false,
              errorMessage: message,
            ),
          ),
        );
    }
  }

  Future<void> _loadMoreOrders() async {
    if (state.isLoadingMore || !state.hasNextPage || state.orders.isLoading) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.currentPage + 1;

    final response = await _getOrdersUseCase.call(
      page: nextPage,
      pageSize: state.pageSize,
    );

    switch (response) {
      case SuccessResponse(data: final result):
        final newItems = result?.orders ?? [];
        final currentItems = List<OrderEntity>.from(state.orders.data ?? []);
        currentItems.addAll(newItems);

        emit(
          state.copyWith(
            isLoadingMore: false,
            currentPage: result?.currentPage ?? nextPage,
            hasNextPage: result?.hasNextPage ?? false,
            orders: state.orders.copyWith(data: currentItems),
          ),
        );
      case ErrorResponse():
        emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _loadOrderDetails(String orderId) async {
    emit(state.copyWith(orderDetails: BaseState.loading()));

    final response = await _getOrderDetailsUseCase.call(orderId: orderId);

    switch (response) {
      case SuccessResponse(data: final details):
        if (details != null) {
          emit(state.copyWith(orderDetails: BaseState.success(details)));
        } else {
          emit(
            state.copyWith(
              orderDetails: const BaseState(
                isLoading: false,
                errorMessage: 'Order details not found',
                data: null,
              ),
            ),
          );
        }
      case ErrorResponse(errorMessage: final message):
        emit(state.copyWith(orderDetails: BaseState.error(message)));
    }
  }
}
