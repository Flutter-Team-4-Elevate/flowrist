import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_timeline_entity.dart';
import 'package:intl/intl.dart';

extension TrackingTimelineExtension on TrackingTimelineEntity {
  String displayTitle(AppLocalizations l10n) {
    switch (status) {
      case 'PLACED':
        return l10n.placed;
      case 'PREPARING':
        return l10n.preparing;
      case 'PICKED_UP':
        return l10n.pickedUp;
      case 'OUT_FOR_DELIVERY':
        return l10n.outForDelivery;
      case 'ARRIVED':
        return l10n.arrived;
      case 'AWAITING_DELIVERY_CONFIRMATION':
        return l10n.awaitingDeliveryConfirmation;
      case 'DELIVERED':
        return l10n.delivered;
      default:
        return status;
    }
  }

  String formattedDate([String? locale]) {
    if (occurredAt == null) return '';

    return DateFormat(
      'dd MMM yyyy - HH:mm',
      locale,
    ).format(occurredAt!.toLocal());
  }
}
