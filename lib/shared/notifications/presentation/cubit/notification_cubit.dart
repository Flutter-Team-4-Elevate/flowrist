import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/device_id/device_id_services.dart';
import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/shared/notifications/domain/use_cases/get_notification_status_usecase.dart';
import 'package:flowrist/shared/notifications/domain/use_cases/update_notification_status_usecase.dart';
import 'notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(
    this._updateNotificationStatusUseCase,
    this._getNotificationStatusUseCase,
  ) : super(const NotificationState());

  final UpdateNotificationStatusUseCase _updateNotificationStatusUseCase;

  final GetNotificationStatusUseCase _getNotificationStatusUseCase;

  Future<void> getNotificationStatus() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final enabled = await _getNotificationStatusUseCase();

      emit(state.copyWith(isEnabled: enabled, isLoading: false));
    } catch (e) {
      debugPrint('Failed to get notification status: $e');

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load notification status',
        ),
      );
    }
  }

  Future<void> updateNotificationStatus(bool enabled) async {
    final previousValue = state.isEnabled;

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final deviceId = await getIt<DeviceIdService>().getDeviceId();

      final response = await _updateNotificationStatusUseCase.call(
        deviceId: deviceId,
        enabled: enabled,
      );

      switch (response) {
        case SuccessResponse():
          emit(state.copyWith(isEnabled: enabled, isLoading: false));

        case ErrorResponse():
          emit(
            state.copyWith(
              isEnabled: previousValue,
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          );
      }
    } catch (e) {
      debugPrint('Failed to update notification status: $e');

      emit(
        state.copyWith(
          isEnabled: previousValue,
          isLoading: false,
          errorMessage: 'Failed to update notification status',
        ),
      );
    }
  }
}
