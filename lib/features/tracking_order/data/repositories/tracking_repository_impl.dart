import 'dart:async';
import 'package:flowrist/config/base_response/base_response.dart';
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

  TrackingRepositoryImpl(this._remoteDataSource, this._notificationDataSource);

  final Map<String, OrderTrackingEntity> _currentTracking = {};

  final Map<String, StreamController<OrderTrackingEntity>> _controllers = {};

  final Map<String, StreamSubscription<TrackingUpdateEntity>>
  _notificationSubscriptions = {};

  @override
  Stream<OrderTrackingEntity> watchOrderTracking(String orderId) async* {
    final controller = _getController(orderId);

    final response = await _remoteDataSource.getOrderTracking(orderId);

    if (response is ErrorResponse<OrderTrackingModel>) {
      throw Exception(response.errorMessage);
    }

    if (response is SuccessResponse<OrderTrackingModel>) {
      final tracking = response.data?.toEntity();

      if (tracking == null) {
        throw Exception('Tracking data is empty');
      }

      _currentTracking[orderId] = tracking;

      yield tracking;

      _startNotificationListener(orderId);
    }

    // Continue listening for updates.
    yield* controller.stream;
  }

  StreamController<OrderTrackingEntity> _getController(String orderId) {
    return _controllers.putIfAbsent(
      orderId,
      () => StreamController<OrderTrackingEntity>.broadcast(),
    );
  }

  void _startNotificationListener(String orderId) {
    if (_notificationSubscriptions.containsKey(orderId)) {
      return;
    }

    _notificationSubscriptions[orderId] = _notificationDataSource
        .trackingUpdates
        .listen((update) async {
          if (update.orderId != orderId) {
            return;
          }

          await _handleTrackingUpdate(update);
        });
  }

  Future<void> _handleTrackingUpdate(TrackingUpdateEntity update) async {
    try {
      final response = await _remoteDataSource.getOrderTracking(update.orderId);

      if (response is! SuccessResponse<OrderTrackingModel>) {
        return;
      }

      final tracking = response.data?.toEntity();

      if (tracking == null) {
        return;
      }

      _currentTracking[update.orderId] = tracking;

      final controller = _controllers[update.orderId];

      if (controller != null && !controller.isClosed) {
        controller.add(tracking);
      }
    } catch (_) {
      // Ignore notification refresh errors.
      // The next notification can retry the API refresh.
    }
  }

  @override
  Future<BaseResponse<dynamic>> confirmDelivery(String orderId) async {
    final response = await _remoteDataSource.confirmDelivery(orderId);

    switch (response) {
      case SuccessResponse<dynamic>():
        return SuccessResponse(null);

      case ErrorResponse<dynamic>():
        return ErrorResponse(response.errorMessage);
    }
  }

  /// Closes the stream and notification listener for one order.
  Future<void> closeOrderTracking(String orderId) async {
    await _notificationSubscriptions.remove(orderId)?.cancel();

    final controller = _controllers.remove(orderId);

    if (controller != null && !controller.isClosed) {
      await controller.close();
    }

    _currentTracking.remove(orderId);
  }

  /// Closes every active order tracking stream.
  Future<void> dispose() async {
    final subscriptions = _notificationSubscriptions.values.toList();

    for (final subscription in subscriptions) {
      await subscription.cancel();
    }

    _notificationSubscriptions.clear();

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
