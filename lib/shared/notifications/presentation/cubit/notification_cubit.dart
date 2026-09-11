import 'package:flowrist/config/device_id/device_id_services.dart';
import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/shared/notifications/domain/use_cases/update_notification_status_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationCubit extends Cubit<bool> {
  NotificationCubit(
    this._updateNotificationStatusUseCase,
  ) : super(true);

  final UpdateNotificationStatusUseCase
      _updateNotificationStatusUseCase;

  Future<void> updateNotificationStatus(bool enabled) async {
    try {
      final deviceId =
          await getIt<DeviceIdService>().getDeviceId();

      await _updateNotificationStatusUseCase.call(
        deviceId: deviceId,
        enabled: enabled,
      );

      emit(enabled);
    } catch (_) {}
  }
}