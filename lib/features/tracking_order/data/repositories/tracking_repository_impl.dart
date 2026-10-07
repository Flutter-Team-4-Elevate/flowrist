import 'dart:async';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/notifications/local_notification_service.dart';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/features/tracking_order/data/data_sources/contract/remote/tracking_notification_data_source.dart';
import 'package:flowrist/features/tracking_order/data/data_sources/contract/remote/tracking_remote_data_source.dart';
import 'package:flowrist/features/tracking_order/data/models/order_tracking_model.dart';
import 'package:flowrist/features/tracking_order/domain/entities/order_tracking_entity.dart';
import 'package:flowrist/features/tracking_order/domain/entities/tracking_update_entity.dart';
import 'package:flowrist/features/tracking_order/domain/repositories/tracking_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TrackingRepository)
class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource _remoteDataSource;
  final TrackingNotificationDataSource _notificationDataSource;
  final SecureStorageService _secureStorage;
  final LocalNotificationService _localNotificationService;

  TrackingRepositoryImpl(
    this._remoteDataSource,
    this._notificationDataSource,
    this._secureStorage,
    this._localNotificationService,
  );

  final Map<String, OrderTrackingEntity> _currentTracking = {};

  final Map<String, StreamController<BaseResponse<OrderTrackingEntity>>>
  _controllers = {};

  final Map<String, Timer> _pollingTimers = {};

  StreamSubscription<TrackingUpdateEntity>? _notificationSubscription;

  // ============================================================
  // ORDER TRACKING
  // ============================================================

  @override
  Stream<BaseResponse<OrderTrackingEntity>> watchOrderTracking(String orderId) {
    return _getController(orderId).stream;
  }

  StreamController<BaseResponse<OrderTrackingEntity>> _getController(
    String orderId,
  ) {
    return _controllers.putIfAbsent(
      orderId,
      () => StreamController<BaseResponse<OrderTrackingEntity>>.broadcast(
        onListen: () => _startTracking(orderId),
        onCancel: () => _onTrackingStreamCancelled(orderId),
      ),
    );
  }

  Future<void> _startTracking(String orderId) async {
    _startNotificationListener();

    await _getOrderTracking(orderId);

    if (!_controllers.containsKey(orderId)) {
      return;
    }

    _startPolling(orderId);
  }

  Future<void> _getOrderTracking(String orderId) async {
    final controller = _controllers[orderId];

    if (controller == null || controller.isClosed) {
      return;
    }

    final response = await _remoteDataSource.getOrderTracking(orderId);

    switch (response) {
      case SuccessResponse<OrderTrackingModel>():
        final tracking = response.data?.toEntity();

        if (tracking == null) {
          controller.add(
            ErrorResponse<OrderTrackingEntity>('Tracking data is empty'),
          );
          return;
        }

        _currentTracking[orderId] = tracking;

        controller.add(SuccessResponse<OrderTrackingEntity>(tracking));

      case ErrorResponse<OrderTrackingModel>():
        controller.add(
          ErrorResponse<OrderTrackingEntity>(response.errorMessage),
        );
    }
  }

  // ============================================================
  // POLLING
  // ============================================================

  void _startPolling(String orderId) {
    if (_pollingTimers.containsKey(orderId)) {
      return;
    }

    _pollingTimers[orderId] = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _getOrderTracking(orderId),
    );
  }

  // ============================================================
  // FCM TRACKING UPDATE
  // ============================================================

  void _startNotificationListener() {
    if (_notificationSubscription != null) {
      return;
    }

    _notificationSubscription = _notificationDataSource.trackingUpdates.listen(
      _handleTrackingUpdate,
    );
  }

  Future<void> _handleTrackingUpdate(TrackingUpdateEntity update) async {
    if (!_controllers.containsKey(update.orderId)) {
      return;
    }

    await _getOrderTracking(update.orderId);
  }

  // ============================================================
  // STREAM CLEANUP
  // ============================================================

  Future<void> _onTrackingStreamCancelled(String orderId) async {
    _pollingTimers.remove(orderId)?.cancel();

    final controller = _controllers.remove(orderId);

    _currentTracking.remove(orderId);

    if (controller != null && !controller.isClosed) {
      await controller.close();
    }

    if (_controllers.isEmpty) {
      await _stopNotificationListener();
    }
  }

  Future<void> _stopNotificationListener() async {
    await _notificationSubscription?.cancel();

    _notificationSubscription = null;
  }

  // ============================================================
  // CONFIRM DELIVERY
  // ============================================================

  @override
  Future<BaseResponse<void>> confirmDelivery(String orderId) {
    return _remoteDataSource.confirmDelivery(orderId);
  }

  // ============================================================
  // ESTIMATED DELIVERY
  // ============================================================

  @override
  Future<DateTime?> getEstimatedDeliveryAt() async {
    final savedValue = await _secureStorage.get(
      AppConstants.estimatedDeliveryAtKey,
    );

    if (savedValue.isEmpty) {
      return null;
    }

    return DateTime.tryParse(savedValue);
  }

  // ============================================================
  // LIVE ORDER NOTIFICATION
  // ============================================================

  @override
  Future<void> showOrderTrackingNotification({
    required String orderNumber,
    required String status,
    required int completedSteps,
    required int totalSteps,
  }) async {
    if (status == 'DELIVERED') {
      await stopOrderTrackingNotification();
      return;
    }

    await _localNotificationService.showOrderTrackingNotification(
      orderNumber: orderNumber,
      status: status,
    );
  }

  @override
  Future<void> stopOrderTrackingNotification() async {
    await _localNotificationService.stopLiveOrderNotification();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  Future<void> dispose() async {
    await _stopNotificationListener();

    for (final timer in _pollingTimers.values) {
      timer.cancel();
    }

    _pollingTimers.clear();

    final controllers = _controllers.values.toList();

    for (final controller in controllers) {
      if (!controller.isClosed) {
        await controller.close();
      }
    }

    _controllers.clear();
    _currentTracking.clear();
  }
}
