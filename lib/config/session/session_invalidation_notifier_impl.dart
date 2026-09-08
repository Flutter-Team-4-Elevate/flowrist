import 'package:flowrist/config/session/session_invalidation_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SessionInvalidationNotifier)
class SessionInvalidationNotifierImpl extends ChangeNotifier
    implements SessionInvalidationNotifier {
  @override
  void notifySessionExpired() {
    notifyListeners();
  }
}
