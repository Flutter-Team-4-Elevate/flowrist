extension OrderStatusExtension on String {
  bool get isMapEnabled =>
      ['PICKED_UP', 'OUT_FOR_DELIVERY', 'ARRIVED'].contains(this);

  bool get isAwaitingDeliveryConfirmation =>
      this == 'AWAITING_DELIVERY_CONFIRMATION';
}
