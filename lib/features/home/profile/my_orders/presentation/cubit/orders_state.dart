import 'package:equatable/equatable.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_details_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';

class OrdersState extends Equatable {
  final BaseState<List<OrderEntity>> orders;
  final BaseState<OrderDetailsEntity> orderDetails;
  final int currentPage;
  final bool hasNextPage;
  final bool isLoadingMore;
  final int pageSize;

  const OrdersState({
    this.orders = const BaseState.initial(),
    this.orderDetails = const BaseState.initial(),
    this.currentPage = 1,
    this.hasNextPage = true,
    this.isLoadingMore = false,
    this.pageSize = 10,
  });

  List<OrderEntity> get activeOrders => (orders.data ?? [])
      .where((order) => order.displayStatus == OrderDisplayStatus.active)
      .toList();

  List<OrderEntity> get completedOrders => (orders.data ?? [])
      .where((order) => order.displayStatus == OrderDisplayStatus.completed)
      .toList();

  OrdersState copyWith({
    BaseState<List<OrderEntity>>? orders,
    BaseState<OrderDetailsEntity>? orderDetails,
    int? currentPage,
    bool? hasNextPage,
    bool? isLoadingMore,
    int? pageSize,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      orderDetails: orderDetails ?? this.orderDetails,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  List<Object?> get props => [
    orders,
    orderDetails,
    currentPage,
    hasNextPage,
    isLoadingMore,
    pageSize,
  ];
}
