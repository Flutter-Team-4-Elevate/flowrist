import 'package:flowrist/config/device_id/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeviceIdService {
  final FlutterSecureStorage _storage;
  final UuidGenerator _uuidGenerator;

  DeviceIdService(this._storage, this._uuidGenerator);

  static const String _deviceIdKey = 'device_id';

  Future<String> getDeviceId() async {
    var deviceId = await _storage.read(key: _deviceIdKey);

    if (deviceId == null || deviceId.isEmpty) {
      deviceId = _uuidGenerator.generate();

      await _storage.write(key: _deviceIdKey, value: deviceId);
    }

    return deviceId;
  }
}
