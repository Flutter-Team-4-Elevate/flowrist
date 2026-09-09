import 'package:equatable/equatable.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_details_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';

enum OrdersStatus { initial, loading, success, failure }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<OrderEntity> allOrders;
  final OrderDetailsEntity? selectedOrderDetails;
  final bool isLoadingDetails;
  final String? errorMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.allOrders = const [],
    this.selectedOrderDetails,
    this.isLoadingDetails = false,
    this.errorMessage,
  });

  List<OrderEntity> get activeOrders => allOrders
      .where((order) => order.displayStatus == OrderDisplayStatus.active)
      .toList();

  List<OrderEntity> get completedOrders => allOrders
      .where((order) => order.displayStatus == OrderDisplayStatus.completed)
      .toList();

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderEntity>? allOrders,
    OrderDetailsEntity? selectedOrderDetails,
    bool? isLoadingDetails,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      allOrders: allOrders ?? this.allOrders,
      selectedOrderDetails: selectedOrderDetails ?? this.selectedOrderDetails,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allOrders,
    selectedOrderDetails,
    isLoadingDetails,
    errorMessage,
  ];
}
