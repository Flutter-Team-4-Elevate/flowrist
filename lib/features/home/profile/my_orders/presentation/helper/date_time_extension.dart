import 'package:flowrist/core/constants/app_constants.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime? {
  String toOrderCardDate() {
    if (this == null) return '';
    return DateFormat(AppConstants.orderCardDateFormat).format(this!);
  }

  String toOrderDetailsDate() {
    if (this == null) return '';
    return DateFormat(AppConstants.orderDateFormat).format(this!);
  }
}