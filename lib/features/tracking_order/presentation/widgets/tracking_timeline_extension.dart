import 'package:flowrist/features/tracking_order/domain/entities/tracking_timeline_entity.dart';
import 'package:intl/intl.dart';

extension TrackingTimelineExtension on TrackingTimelineEntity {
  String get displayTitle {
    switch (status) {
      case 'PLACED':
        return 'Received your order';
      case 'PREPARING':
        return 'Preparing your order';
      case 'PICKED_UP':
        return 'Picked up';
      case 'OUT_FOR_DELIVERY':
        return 'Out for delivery';
      case 'DELIVERED':
        return 'Delivered';
      default:
        return status;
    }
  }

  String get formattedDate {
    if (occurredAt == null) return '';

    return DateFormat('dd MMM yyyy - HH:mm').format(occurredAt!.toLocal());
  }
}
