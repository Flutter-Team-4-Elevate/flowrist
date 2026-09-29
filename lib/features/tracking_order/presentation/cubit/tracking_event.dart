sealed class TrackingEvent {}

class StartTracking extends TrackingEvent {
  final String orderId;

  StartTracking({required this.orderId});
}

class ConfirmDelivery extends TrackingEvent {
  final String orderId;

  ConfirmDelivery({required this.orderId});
}
