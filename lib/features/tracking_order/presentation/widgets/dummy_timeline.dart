import 'package:flowrist/features/tracking_order/presentation/widgets/order_status_timeline.dart';
import 'package:flutter/material.dart';

enum OrderStatus { received, preparing, pickedUp, outForDelivery, delivered }

class OrderStatusTimeline extends StatelessWidget {
  const OrderStatusTimeline({super.key});

  static const OrderStatus currentStatus = OrderStatus.preparing;

  @override
  Widget build(BuildContext context) {
    final timeline = [
      {
        'title': 'Received your order',
        'date': '03 Sep 2024 - 2:10',
        'status': OrderStatus.received,
      },
      {
        'title': 'Preparing your order',
        'date': '03 Sep 2024 - 2:30',
        'status': OrderStatus.preparing,
      },
      {
        'title': 'Picked up',
        'date': '03 Sep 2024 - 3:00',
        'status': OrderStatus.pickedUp,
      },
      {
        'title': 'Out for delivery',
        'date': '03 Sep 2024 - 3:30',
        'status': OrderStatus.outForDelivery,
      },
      {
        'title': 'Delivered',
        'date': '03 Sep 2024 - 4:00',
        'status': OrderStatus.delivered,
      },
    ];

    return Column(
      children: List.generate(timeline.length, (index) {
        final item = timeline[index];
        final status = item['status'] as OrderStatus;

        final isCurrent = status == currentStatus;

        return OrderStatusItem(
          title: item['title'] as String,
          date: item['date'] as String,
          isCompleted: status.index < currentStatus.index,
          isCurrent: isCurrent,
          isLast: index == timeline.length - 1,
        );
      }),
    );
  }
}
