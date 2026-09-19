import 'package:flowrist/features/addresses/domain/entities/permission_status_entity.dart';
import 'package:permission_handler/permission_handler.dart';

extension PermissionStatusMapper on PermissionStatus {
  PermissionStatusEntity toEntity() {
    final entity = switch (this) {
      PermissionStatus.denied => PermissionStatusEntity.denied,
      PermissionStatus.granted => PermissionStatusEntity.granted,
      PermissionStatus.restricted => PermissionStatusEntity.restricted,
      PermissionStatus.limited => PermissionStatusEntity.limited,
      PermissionStatus.permanentlyDenied =>
        PermissionStatusEntity.permanentlyDenied,
      PermissionStatus.provisional => PermissionStatusEntity.provisional,
    };

    return entity;
  }
}
