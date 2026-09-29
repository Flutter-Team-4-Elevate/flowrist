import 'dart:async';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/confirm_delivery_use_case.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/watch_order_tracking_use_case.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_event.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackingCubit extends Cubit<TrackingState> {
  final WatchOrderTrackingUseCase _watchOrderTrackingUseCase;
  final ConfirmDeliveryUseCase _confirmDeliveryUseCase;
  final SecureStorageService _secureStorage;

  Timer? _pollingTimer;

  TrackingCubit(
    this._watchOrderTrackingUseCase,
    this._confirmDeliveryUseCase,
    this._secureStorage,
  ) : super(const TrackingState());

  Future<void> doEvent(TrackingEvent event) async {
    switch (event) {
      case StartTracking():
        await _startTracking(event.orderId);

      case ConfirmDelivery():
        await _confirmDelivery(event.orderId);
    }
  }

  Future<void> _startTracking(String orderId) async {
    _pollingTimer?.cancel();

    await _loadEstimatedDelivery();

    // Initial request immediately.
    await _fetchTracking(orderId);

    if (isClosed) return;

    // Continue polling every 5 seconds.
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!isClosed) {
        _fetchTracking(orderId);
      }
    });
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

        // The use case currently returns one API result.
        return;
      }
    } catch (error) {
      if (isClosed) return;

      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<void> _loadEstimatedDelivery() async {
    final savedValue = await _secureStorage.get(
      AppConstants.estimatedDeliveryAtKey,
    );

    if (savedValue.isEmpty || isClosed) {
      return;
    }

    final parsedDate = DateTime.tryParse(savedValue);

    if (parsedDate != null && !isClosed) {
      emit(state.copyWith(estimatedDeliveryAt: parsedDate));
    }
  }

  Future<void> _confirmDelivery(String orderId) async {
    if (isClosed) return;

    emit(state.copyWith(isConfirmingDelivery: true, errorMessage: null));

    try {
      final response = await _confirmDeliveryUseCase(orderId);

      if (isClosed) return;

      if (response is SuccessResponse) {
        emit(
          state.copyWith(
            isConfirmingDelivery: false,
            isDeliveryConfirmed: true,
          ),
        );
      } else if (response is ErrorResponse) {
        emit(
          state.copyWith(
            isConfirmingDelivery: false,
            errorMessage: response.errorMessage,
          ),
        );
      }
    } catch (error) {
      if (isClosed) return;

      emit(
        state.copyWith(
          isConfirmingDelivery: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    _pollingTimer?.cancel();
    return super.close();
  }
}
