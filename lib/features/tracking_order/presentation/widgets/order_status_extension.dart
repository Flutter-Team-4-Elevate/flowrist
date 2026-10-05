extension OrderStatusExtension on String {
  bool get isMapEnabled => [
    'PREPARING',
    'ARRIVED',
    'AWAITING_DELIVERY_CONFIRMATION',
    'DELIVERED',
  ].contains(this);

  bool get isAwaitingDeliveryConfirmation =>
      this == 'AWAITING_DELIVERY_CONFIRMATION';
}
