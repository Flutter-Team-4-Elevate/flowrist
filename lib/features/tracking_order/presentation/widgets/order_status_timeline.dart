import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_timeline_entity.dart';
import 'package:flowrist/features/tracking_order/presentation/widgets/order_status_item.dart';
import 'package:flowrist/features/tracking_order/presentation/widgets/tracking_timeline_extension.dart';
import 'package:flutter/material.dart';

class OrderStatusTimeline extends StatelessWidget {
  final List<TrackingTimelineEntity> timeline;

  const OrderStatusTimeline({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return Column(
      children: timeline.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return OrderStatusItem(
          title: item.displayTitle(l10n),
          date: item.formattedDate(locale),
          isCompleted: item.isCompleted,
          isCurrent: item.isCurrent,
          isLast: index == timeline.length - 1,
        );
      }).toList(),
    );
  }
}
