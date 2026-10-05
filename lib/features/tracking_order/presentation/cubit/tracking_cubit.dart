import 'dart:async';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/confirm_delivery_use_case.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/get_estimated_delivery_use_case.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/get_route_use_case.dart';
import 'package:flowrist/features/tracking_order/domain/use_cases/watch_order_tracking_use_case.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_event.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@injectable
class TrackingCubit extends Cubit<TrackingState> {
  final WatchOrderTrackingUseCase _watchOrderTrackingUseCase;
  final ConfirmDeliveryUseCase _confirmDeliveryUseCase;
  final GetEstimatedDeliveryUseCase _getEstimatedDeliveryUseCase;
  final GetRouteUseCase _getRouteUseCase;

  StreamSubscription<BaseResponse<OrderTrackingEntity>>? _trackingSubscription;

  LatLng? _lastRoutedDriverLocation;

  TrackingCubit(
    this._watchOrderTrackingUseCase,
    this._confirmDeliveryUseCase,
    this._getEstimatedDeliveryUseCase,
    this._getRouteUseCase,
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

    _lastRoutedDriverLocation = null;

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        routePoints: const [],
      ),
    );

    // Load user location.
    await _loadUserLocation();

    if (isClosed) {
      return;
    }

    await _loadEstimatedDelivery();

    if (isClosed) {
      return;
    }

    _trackingSubscription = _watchOrderTrackingUseCase(orderId).listen((
      response,
    ) async {
      if (isClosed) {
        return;
      }

      switch (response) {
        case SuccessResponse<OrderTrackingEntity>():
          final tracking = response.data;

          emit(
            state.copyWith(
              isLoading: false,
              tracking: tracking,
              lastUpdatedAt: DateTime.now(),
              errorMessage: null,
            ),
          );

          await _updateRoute(tracking!);

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

  Future<void> _loadUserLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      if (isClosed) {
        return;
      }

      final userLocation = LatLng(position.latitude, position.longitude);

      emit(state.copyWith(userLocation: userLocation));

      debugPrint(
        '📍 CUBIT USER LOCATION: '
        '${position.latitude}, '
        '${position.longitude}',
      );
    } catch (error) {
      debugPrint('❌ Failed to get user location: $error');
    }
  }

  Future<void> _updateRoute(OrderTrackingEntity tracking) async {
    final driverLocation = tracking.lastKnownLocation;

    if (driverLocation == null) {
      return;
    }

    final driver = LatLng(driverLocation.lat, driverLocation.lng);

    final destination = LatLng(
      tracking.destination.lat,
      tracking.destination.lng,
    );

    if (_lastRoutedDriverLocation != null) {
      final distance = Geolocator.distanceBetween(
        _lastRoutedDriverLocation!.latitude,
        _lastRoutedDriverLocation!.longitude,
        driver.latitude,
        driver.longitude,
      );

      if (distance < 50) {
        return;
      }
    }

    _lastRoutedDriverLocation = driver;

    final coordinates =
        '${driver.longitude},${driver.latitude};'
        '${destination.longitude},${destination.latitude}';

    try {
      final response = await _getRouteUseCase(coordinates: coordinates);

      if (isClosed) {
        return;
      }

      if (response.code != 'Ok') {
        return;
      }

      if (response.points.isEmpty) {
        return;
      }

      emit(state.copyWith(routePoints: response.points));
    } catch (error) {
      debugPrint('❌ Routing failed: $error');

      // Routing failure should not stop tracking.
    }
  }

  Future<void> _loadEstimatedDelivery() async {
    final estimatedDelivery = await _getEstimatedDeliveryUseCase();

    if (estimatedDelivery != null && !isClosed) {
      emit(state.copyWith(estimatedDeliveryAt: estimatedDelivery));
    }
  }

  Future<void> _confirmDelivery(String orderId) async {
    if (isClosed) {
      return;
    }

    emit(state.copyWith(isConfirmingDelivery: true, errorMessage: null));

    try {
      final response = await _confirmDeliveryUseCase(orderId);

      if (isClosed) {
        return;
      }

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
      if (isClosed) {
        return;
      }

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
