import 'package:equatable/equatable.dart';

class OrderTrackingNotificationData extends Equatable {
  final String title;
  final String body;
  final int progress;

  const OrderTrackingNotificationData({
    required this.title,
    required this.body,
    required this.progress,
  });

  @override
  List<Object?> get props => [title, body, progress];
}
