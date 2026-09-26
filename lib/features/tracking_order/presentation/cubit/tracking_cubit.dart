import 'dart:async';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/confirm_delivery_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/use_cases/watch_order_tracking_use_case.dart';
import 'tracking_state.dart';

@injectable
class TrackingCubit extends Cubit<TrackingState> {
  final WatchOrderTrackingUseCase _watchOrderTrackingUseCase;
  final ConfirmDeliveryUseCase _confirmDeliveryUseCase;
  Timer? _pollingTimer;

  TrackingCubit(this._watchOrderTrackingUseCase, this._confirmDeliveryUseCase)
    : super(const TrackingState());

  Future<void> startTracking(String orderId) async {
    _pollingTimer?.cancel();

    await _fetchTracking(orderId);

    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _fetchTracking(orderId),
    );
  }

  Future<void> _fetchTracking(String orderId) async {
    try {
      final stream = _watchOrderTrackingUseCase(orderId);

      await for (final tracking in stream) {
        if (isClosed) return;

        emit(
          state.copyWith(
            isLoading: false,
            tracking: tracking,
            errorMessage: null,
          ),
        );

        // We only need the first API response.
        break;
      }
    } catch (error) {
      if (isClosed) return;

      // print('TRACKING API ERROR: $error');

      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  @override
  Future<void> close() async {
    _pollingTimer?.cancel();
    return super.close();
  }

  Future<void> confirmDelivery(String orderId) async {
    emit(state.copyWith(isConfirmingDelivery: true, errorMessage: null));

    final response = await _confirmDeliveryUseCase(orderId);

    if (response is SuccessResponse) {
      emit(
        state.copyWith(isConfirmingDelivery: false, isDeliveryConfirmed: true),
      );
    } else if (response is ErrorResponse) {
      emit(
        state.copyWith(
          isConfirmingDelivery: false,
          errorMessage: response.errorMessage,
        ),
      );
    }
  }
}
