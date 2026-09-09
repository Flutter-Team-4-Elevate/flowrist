sealed class OrdersEvents {
  const OrdersEvents();
}

class LoadOrdersEvent extends OrdersEvents {
  final int page;
  final int pageSize;
  const LoadOrdersEvent({this.page = 1, this.pageSize = 10});
}

class LoadOrderDetailsEvent extends OrdersEvents {
  final String orderId;
  const LoadOrderDetailsEvent(this.orderId);
}
