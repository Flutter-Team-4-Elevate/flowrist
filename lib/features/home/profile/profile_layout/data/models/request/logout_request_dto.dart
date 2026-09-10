class LogoutRequestDto {
  final String refreshToken;
  final String deviceId;

  const LogoutRequestDto({required this.refreshToken, this.deviceId = ''});

  Map<String, dynamic> toJson() {
    return {'refreshToken': refreshToken, 'deviceId': deviceId};
  }
}
