import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/service_status_entity.dart';

extension ServiceStatusMapper on ServiceStatus {
  ServiceStatusEntity toEntity() {
    final entity = switch (this) {
      ServiceStatus.disabled => ServiceStatusEntity.disabled,
      ServiceStatus.enabled => ServiceStatusEntity.enabled,
      ServiceStatus.notApplicable => ServiceStatusEntity.notApplicable,
    };

    return entity;
  }
}
