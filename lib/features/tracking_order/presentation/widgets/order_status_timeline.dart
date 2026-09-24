import 'package:flowrist/features/tracking_order/domain/entities/tracking_timeline_entity.dart';
import 'package:flowrist/features/tracking_order/presentation/widgets/dummy_timeline.dart';
import 'package:flutter/material.dart';

class OrderStatusTimeline extends StatelessWidget {
  final List<TrackingTimelineEntity> timeline;

  const OrderStatusTimeline({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(timeline.length, (index) {
        final item = timeline[index];

        return OrderStatusItem(
          title: _getTitle(item.status),
          date: _formatDate(item.occurredAt),
          isCompleted: item.isCompleted,
          isCurrent: item.isCurrent,
          isLast: index == timeline.length - 1,
        );
      }),
    );
  }

  String _getTitle(String status) {
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

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)} '
        '${date.year} - '
        '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }
}
