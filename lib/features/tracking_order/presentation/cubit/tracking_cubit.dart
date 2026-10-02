import 'dart:async';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/confirm_delivery_use_case.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/get_estimated_delivery_use_case.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/watch_order_tracking_use_case.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_event.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackingCubit extends Cubit<TrackingState> {
  final WatchOrderTrackingUseCase _watchOrderTrackingUseCase;
  final ConfirmDeliveryUseCase _confirmDeliveryUseCase;
  final GetEstimatedDeliveryUseCase _getEstimatedDeliveryUseCase;

  StreamSubscription<BaseResponse<OrderTrackingEntity>>? _trackingSubscription;

  TrackingCubit(
    this._watchOrderTrackingUseCase,
    this._confirmDeliveryUseCase,
    this._getEstimatedDeliveryUseCase,
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
    await _trackingSubscription?.cancel();

    if (isClosed) return;

    // Start loading immediately when the screen starts listening.
    emit(state.copyWith(isLoading: true, errorMessage: null));

    // Load locally saved estimated delivery time.
    await _loadEstimatedDelivery();

    if (isClosed) return;

    // Repository starts the initial API request when this stream
    // gets its first listener.
    _trackingSubscription = _watchOrderTrackingUseCase(orderId).listen((
      response,
    ) {
      if (isClosed) return;

      switch (response) {
        case SuccessResponse<OrderTrackingEntity>():
          emit(
            state.copyWith(
              isLoading: false,
              tracking: response.data,
              lastUpdatedAt: DateTime.now(),
              errorMessage: null,
            ),
          );

        case ErrorResponse<OrderTrackingEntity>():
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          );
      }
    });
  }

  Future<void> _loadEstimatedDelivery() async {
    final estimatedDelivery = await _getEstimatedDeliveryUseCase();

    if (estimatedDelivery != null && !isClosed) {
      emit(state.copyWith(estimatedDeliveryAt: estimatedDelivery));
    }
  }

  Future<void> _confirmDelivery(String orderId) async {
    if (isClosed) return;

    emit(state.copyWith(isConfirmingDelivery: true, errorMessage: null));

    try {
      final response = await _confirmDeliveryUseCase(orderId);

      if (isClosed) return;

      switch (response) {
        case SuccessResponse<void>():
          emit(
            state.copyWith(
              isConfirmingDelivery: false,
              isDeliveryConfirmed: true,
            ),
          );

        case ErrorResponse<void>():
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
    await _trackingSubscription?.cancel();
    return super.close();
  }
}
