import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class DeviceIdService {
  final FlutterSecureStorage _storage;

  DeviceIdService(this._storage);

  static const String _deviceIdKey = 'device_id';

  Future<String> getDeviceId() async {
    var deviceId = await _storage.read(key: _deviceIdKey);

    if (deviceId == null || deviceId.isEmpty) {
      deviceId = const Uuid().v4();

      await _storage.write(
        key: _deviceIdKey,
        value: deviceId,
      );
    }

    return deviceId;
  }
}