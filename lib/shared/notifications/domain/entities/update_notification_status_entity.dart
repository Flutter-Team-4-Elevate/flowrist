class UpdateNotificationStatusEntity {
  final String deviceId;
  final bool notificationsEnabled;

  const UpdateNotificationStatusEntity({
    required this.deviceId,
    required this.notificationsEnabled,
  });
}