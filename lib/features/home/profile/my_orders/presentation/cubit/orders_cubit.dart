import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/use_cases/get_order_details_use_case.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/use_cases/get_orders_use_case.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_events.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_state.dart';
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
      case LoadOrderDetailsEvent():
        _loadOrderDetails(event.orderId);
    }
  }

  Future<void> _loadOrders(int page, int pageSize) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    final response = await _getOrdersUseCase.call(
      page: page,
      pageSize: pageSize,
    );
    switch (response) {
      case SuccessResponse(data: final orders):
        emit(state.copyWith(status: OrdersStatus.success, allOrders: orders));
      case ErrorResponse(errorMessage: final message):
        emit(
          state.copyWith(status: OrdersStatus.failure, errorMessage: message),
        );
    }
  }

  Future<void> _loadOrderDetails(String orderId) async {
    emit(state.copyWith(isLoadingDetails: true));
    final response = await _getOrderDetailsUseCase.call(orderId: orderId);
    switch (response) {
      case SuccessResponse(data: final details):
        emit(
          state.copyWith(
            isLoadingDetails: false,
            selectedOrderDetails: details,
          ),
        );
      case ErrorResponse(errorMessage: final message):
        emit(state.copyWith(isLoadingDetails: false, errorMessage: message));
    }
  }
}
